import express from "express";
import bodyParser from "body-parser";
import pg from "pg";
import path from 'path';
import Stripe from "stripe";
import dotenv from 'dotenv';

dotenv.config();

const stripe = new Stripe(process.env.STRIPE_PRIVATE_KEY);

const app = express();
const port = process.env.PORT || 3000;

app.use(express.static("public"));
app.use(bodyParser.urlencoded({extended : true}));


const db = new pg.Client({
    connectionString: process.env.POSTGRES_URL,
});

let loginStatus = "";
let currUserId = "";

db.connect();

app.get("/",async(req,res) => {
    await db.query("UPDATE orders SET complete=$1 WHERE complete=$2;",[1,0]);
    res.render("index.ejs",{attribute : loginStatus});
});
app.post("/home",(req,res)=>{
    res.redirect("/");
});

app.post("/view",async (req,res)=>{
    try{
        const prodName = req.body.prod;
        let prod = await db.query("SELECT * FROM items WHERE name = $1;",[prodName]);
        const id = prod.rows[0].id;
        const image = prod.rows[0].image;
        const rating = prod.rows[0].rating;
        const desp = prod.rows[0].description;
        const price = prod.rows[0].price;
        res.render("view.ejs",{id:id,name:prodName, img:image, rating:rating, price:price, description:desp});
    }catch(err){
        res.send("Cannot view the item")
        console.log("Cannot view the item");
    }
   
});

app.post("/category",async (req,res)=>{
    try{
        const cat = req.body.ha;
        let products = await db.query("SELECT * FROM items WHERE category = $1;",[cat]);
        res.render("viewall.ejs",{items : products.rows, attribute : loginStatus});
    }catch(err){
        res.set('Content-Type', 'text/html');
        res.send(Buffer.from('<h2>No items available for this category</h2>'));
    }
});

app.post("/buy",async (req,res)=>{
    try{
        if(typeof(req.body.buybutton) == 'undefined'){
            const qty = req.body.qty;
            const prodName = req.body.cartbutton;
            console.log(prodName);
            let prod = await db.query("SELECT * FROM items WHERE name = $1;",[prodName]);
            const id = prod.rows[0].id;
            const price = prod.rows[0].price;
            const value = price*qty;
            await db.query("INSERT INTO cart (user_id,item_id,value) VALUES ($1,$2,$3);",[currUserId,id,value]);
            const image = prod.rows[0].image;
            const rating = prod.rows[0].rating;
            const desp = prod.rows[0].description;
            
            res.render("view.ejs",{id:id,name:prodName, img:image, rating:rating, price:price, description:desp});
        }else{
            /*checkout page */

            if(currUserId.length === 0){
                res.render("login.ejs");
            }
            else{
                const prodid = req.body.buybutton;
                const qty = req.body.qty;

                let products = await db.query("SELECT * FROM items WHERE id = $1;",[prodid]);
                const price = products.rows[0].price;
                const value = qty*price;
                
                await db.query("INSERT INTO orders(user_id,item_id,process,complete,value) VALUES ($1,$2,$3,$4,$5);",[currUserId,prodid,1,0,value]);
                
                let user = await db.query("SELECT * FROM ud JOIN users ON users.id = ud.id WHERE users.id = $1;",[currUserId]);

                const add1 = user.rows[0].add1;
                const add2 = user.rows[0].add2;
                const ph = user.rows[0].ph;
                const city = user.rows[0].city;
                const state = user.rows[0].state;
                const pin = user.rows[0].pincode;
                const name = user.rows[0].name;

                console.log(qty);
                res.render("add.ejs",{add1:add1, add2:add2, ph:ph, city:city, state:state, pin:pin, name:name});
            }
        } 
    }catch(err){
        res.send("Item is already present in cart!");
        console.log(err);
    }
});

app.get("/cartbuy",async (req,res)=>{
    let cartProds = await db.query("SELECT * FROM cart WHERE user_id = $1;",[currUserId]);
    for(let prod of cartProds.rows){
        await db.query("INSERT INTO orders(process,complete,user_id,item_id,value) VALUES ($1,$2,$3,$4,$5);",[1,0,currUserId,prod.item_id,prod.value]);
    }

    let user = await db.query("SELECT * FROM ud JOIN users ON users.id = ud.id WHERE users.id = $1;",[currUserId]);

    const add1 = user.rows[0].add1;
    const add2 = user.rows[0].add2;
    const ph = user.rows[0].ph;
    const city = user.rows[0].city;
    const state = user.rows[0].state;
    const pin = user.rows[0].pincode;
    const name = user.rows[0].name;

    res.render("add.ejs",{add1:add1, add2:add2, ph:ph, city:city, state:state, pin:pin, name:name});
});

app.post("/cart",async (req,res)=>{
    try{
        let products = await db.query("SELECT * FROM cart JOIN users ON users.id = cart.user_id JOIN items ON items.id = cart.item_id WHERE user_id = $1;",[currUserId]);
        let total = await db.query("SELECT SUM(value) FROM cart JOIN users ON users.id = cart.user_id JOIN items ON items.id = cart.item_id WHERE user_id = $1;",[currUserId]);
        res.render("cart.ejs",{items : products.rows,total : total.rows[0]});
    }catch(err){
        res.send("ERROR");
        console.log(err.rows);
    }
});

app.post("/delete",async (req,res)=>{
    try{
        const id = req.body.delbtn;
        await db.query("DELETE FROM cart WHERE item_id = $1 and user_id = $2",[id,currUserId]);
        let products = await db.query("SELECT * FROM cart JOIN users ON users.id = cart.user_id JOIN items ON items.id = cart.item_id WHERE user_id = $1;",[currUserId]);
        let total = await db.query("SELECT SUM(price) FROM cart JOIN users ON users.id = cart.user_id JOIN items ON items.id = cart.item_id WHERE user_id = $1;",[currUserId]);
        res.render("cart.ejs",{items : products.rows,total : total.rows[0]});
    }
    catch(err){
        res.send("DELETE ERROR");
        console.log(err);
    }
});

app.post("/search",async (req,res)=>{
    try{
        const prodName = req.body.searchitem;
        let prod = await db.query("SELECT * FROM items WHERE name = $1;",[prodName]);
        const category = prod.rows[0].category;
        const id = prod.rows[0].id;
        let products =  await db.query("SELECT * FROM items WHERE category = $1 ORDER BY id = $2 DESC;",[category,id]);
        res.render("viewall.ejs",{items : products.rows, attribute : loginStatus});
    }catch(err){
        console.log("err");
    }
});

app.post("/login",async (req,res)=>{
    res.render("login.ejs");
});

app.post("/signin",async (req,res)=>{
    try{
        const userName = req.body.email;
        const pass = req.body.password;
        let user = await db.query("SELECT * FROM users WHERE email = $1;",[userName]);
        const acpass = user.rows[0].password;
        if(pass === acpass){
            loginStatus = "hidden";
            currUserId = user.rows[0].id;
            res.redirect("/");
        }else{
            res.render("login.ejs",{pass1 : pass, pass2 : acpass});
        }
    }catch(err){
        res.send("User does not exist");
        console.log("User does not exist");
    }
});

app.post("/sign", async (req,res)=>{
    res.render("signup.ejs",{status : true});
});

app.post("/signup",async (req,res)=>{
    try{
        const userName = req.body.email;
        const pass = req.body.password;
        const confirmPass = req.body.repassword;

        if(pass === confirmPass){
            await db.query("INSERT INTO users (email,password) VALUES ($1,$2);"[userName,pass]);
            let user = await db.query("SELECT * FROM users WHERE email = $1;",[userName]);
            currUserId = user.rows[0].id;
            await db.query("INSERT INTO ud (id) VALUES ($1);",[currUserId]);
            loginStatus = "hidden";
            res.redirect("/");
        }else{
            res.render("signup.ejs",{status:false});
        }
    }catch(err){
        console.log(err);
    }
    
});

app.get("/orders", async(req,res)=>{
    const products = await db.query('SELECT * FROM orders JOIN items ON item_id = items.id WHERE complete=$1 and user_id=$2',[1,currUserId]);
    res.render("orders.ejs",{items:products.rows});
});

app.post("/checkout1", async(req,res)=>{
    try{
        const add1 = req.body.add1;
        const add2 = req.body.add2;
        const ph = req.body.phone;
        const city = req.body.city;
        const state = req.body.state;
        const pin = req.body.pin;
        const name = req.body.name;

        await db.query("UPDATE ud SET add1=$1, add2=$2, city=$3, state=$4, pincode=$5, ph=$6, name=$7 WHERE id=$8;",[add1,add2,city,state,pin,ph,name,currUserId]);

        let user = await db.query("SELECT * FROM ud WHERE id = $1;",[currUserId]);

        const add11 = user.rows[0].add1;
        const add21 = user.rows[0].add2;
        const ph1 = user.rows[0].ph;
        const city1 = user.rows[0].city;
        const state1 = user.rows[0].state;
        const pin1 = user.rows[0].pincode;
        const name1 = user.rows[0].name;

        res.render("add.ejs",{add1:add11, add2:add21, ph:ph1, city:city1, state:state1, pin:pin1, name:name1});
    }catch(err){
        res.status(500).send(err);
    }
});


app.post("/create-checkout-session",async(req,res)=>{
    try{

        const result = await db.query('SELECT * FROM orders JOIN items ON item_id = items.id WHERE complete=$1 and user_id=$2',[0,currUserId]);
        const products = result.rows;

    // Format products for Stripe
    const line_items = [] ;
    for await (const item of products) {
        line_items.push({
            price_data: {
                currency: 'inr',
                product_data: {
                    name: item.name,
                  },
                  unit_amount:(item.price*100),
                },
                
                quantity: (item.value/item.price),
         });
    }

        const session = await stripe.checkout.sessions.create({
            payment_method_types:['card'],
            mode:'payment',
            line_items: line_items,
            success_url: `${process.env.SERVER_URL}/complete.html`,
            cancel_url: `${process.env.SERVER_URL}/failed.html`
        })
        res.json({url : session.url});
    }catch(err){
        console.log(err);
    }
    
});

app.post("/cancel",async(req,res)=>{
    const id = req.body.cancel;
    res.render("cancel.ejs",{id:id});
});

app.post("/cancel-order",async(req,res)=>{
    const id = req.body.item;
    await db.query("DELETE FROM orders WHERE item_id = $1 and user_id = $2;",[id,currUserId]);
    res.redirect("/orders");
})

app.listen(port,()=>{
    console.log(`Server is running on port ${port}`);
});