PGDMP                         |         
   emSolution    13.15    13.15     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    90112 
   emSolution    DATABASE     p   CREATE DATABASE "emSolution" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1252';
    DROP DATABASE "emSolution";
                postgres    false            �            1259    114688    cart    TABLE     l   CREATE TABLE public.cart (
    item_id integer NOT NULL,
    user_id integer NOT NULL,
    value integer
);
    DROP TABLE public.cart;
       public         heap    postgres    false            �            1259    90115    items    TABLE     �   CREATE TABLE public.items (
    id integer NOT NULL,
    price integer,
    name character varying(45),
    rating double precision,
    description text,
    image text,
    category character varying(45),
    cart integer
);
    DROP TABLE public.items;
       public         heap    postgres    false            �            1259    90113    items_id_seq    SEQUENCE     �   CREATE SEQUENCE public.items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.items_id_seq;
       public          postgres    false    201            �           0    0    items_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;
          public          postgres    false    200            �            1259    122883    orders    TABLE     �   CREATE TABLE public.orders (
    process integer DEFAULT 0,
    complete integer DEFAULT 0,
    value integer,
    user_id integer,
    item_id integer
);
    DROP TABLE public.orders;
       public         heap    postgres    false            �            1259    131072    ud    TABLE     �   CREATE TABLE public.ud (
    id integer NOT NULL,
    add1 text,
    add2 text,
    city character varying(45),
    state character varying(45),
    pincode integer,
    ph integer,
    name character varying(45)
);
    DROP TABLE public.ud;
       public         heap    postgres    false            �            1259    106498    users    TABLE     �   CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(45),
    password character varying(10),
    address text,
    phone integer
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    106496    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    203            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    202            7           2604    90118    items id    DEFAULT     d   ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);
 7   ALTER TABLE public.items ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    201    200    201            8           2604    106501    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    202    203            �          0    114688    cart 
   TABLE DATA           7   COPY public.cart (item_id, user_id, value) FROM stdin;
    public          postgres    false    204   Q!       �          0    90115    items 
   TABLE DATA           \   COPY public.items (id, price, name, rating, description, image, category, cart) FROM stdin;
    public          postgres    false    201   �!       �          0    122883    orders 
   TABLE DATA           L   COPY public.orders (process, complete, value, user_id, item_id) FROM stdin;
    public          postgres    false    205   <*       �          0    131072    ud 
   TABLE DATA           L   COPY public.ud (id, add1, add2, city, state, pincode, ph, name) FROM stdin;
    public          postgres    false    206   �*       �          0    106498    users 
   TABLE DATA           D   COPY public.users (id, email, password, address, phone) FROM stdin;
    public          postgres    false    203   $+       �           0    0    items_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.items_id_seq', 11, true);
          public          postgres    false    200            �           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 3, true);
          public          postgres    false    202            @           2606    114692    cart cart_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (item_id, user_id);
 8   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_pkey;
       public            postgres    false    204    204            <           2606    90123    items items_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.items DROP CONSTRAINT items_pkey;
       public            postgres    false    201            B           2606    131079 
   ud ud_pkey 
   CONSTRAINT     H   ALTER TABLE ONLY public.ud
    ADD CONSTRAINT ud_pkey PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.ud DROP CONSTRAINT ud_pkey;
       public            postgres    false    206            >           2606    106503    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    203            C           2606    114693    cart cart_item_id_fkey    FK CONSTRAINT     u   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(id);
 @   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_item_id_fkey;
       public          postgres    false    201    204    2876            D           2606    114698    cart cart_user_id_fkey    FK CONSTRAINT     u   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 @   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_user_id_fkey;
       public          postgres    false    2878    204    203            F           2606    139269    orders orders_item_id_fkey    FK CONSTRAINT     y   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(id);
 D   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_item_id_fkey;
       public          postgres    false    2876    201    205            E           2606    139264    orders orders_user_id_fkey    FK CONSTRAINT     y   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 D   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_user_id_fkey;
       public          postgres    false    2878    205    203            G           2606    131080    ud ud_id_fkey    FK CONSTRAINT     g   ALTER TABLE ONLY public.ud
    ADD CONSTRAINT ud_id_fkey FOREIGN KEY (id) REFERENCES public.users(id);
 7   ALTER TABLE ONLY public.ud DROP CONSTRAINT ud_id_fkey;
       public          postgres    false    206    203    2878            �   /   x�3�4�4���2�\�@��L�SSK. ��̒+F��� ��      �   �  x��X]s�8|�ż�N��I���&�Ƶ�[Wb+UW����5I0 hG�����xw/1M�Ġ��gƓ�������{��If�yB�R�Y�M�e�^��d����ji�ڔ��$�*�%����E�_U�![�L�U&�ҕ���*�޸�q���Q�FW�p���d4���)-u��F�g�[m.i2]�4�����/�(ii�C`
/|���i��������1�d��A�\ֲ�9$]Q�EN��q�6�}��[#/i�}5<J��j�_ ���l�:a8r���n�8��U�����lz1���M�vt��
|�ZWx�э% hpN�)G�QJ������
m��wq���f�9�R+�𜀔���ҕD���~Bd�o�(6]!X�� �WqU�0t�\(�֢f�����:Yb͍*eeC��uY�̑U?$�F9�*����Ļ�uF�
@�6�)}��}�[I�*eE�1��)R�駰�ýn����B�9N��ҵ�aD�[i�v"g�������1l���yK�C?^2�[�$\ʟ�A�1���4~�(M7�~̳r�g�Ind��!���49�'������=QY�����h:^~<]���' -9��⚱9勔T.E�C��P!0z	ѝ��t-s�����x��h�h�7/�;���:H����?S���x���z+l���W���蒩��_�?���F�1��K�
Q��3[H��*�QN �t�p��*x��Ί��1�B=�!��������
���k;�|Fz;����\��Y�!DKO�q\׷�Ix ����jx&u,���U�'���$9��.LިJ�S������G��(W������S����)e��<�kz�zO�&�u�XD�9��ᗇT$rق[ɞY&�������^=��8�^AO_���U2� �#ʒs̛x:����3�Nw�_h+E�b� \V:Z5��T#��j��+�Y 6K���E2���ʛ�/D�I�=���̓��q��� ,���tua�l6��Ǩ �5��3���������{�/�X�,+�@��S�/��y��k@P9�gN�SO@�e\�C����#�B�r&�/���<V2�	4�p��1�=���f�mT�[�Y�~:�J����US�`Xw�R�VZ˱�NӀk�1�A�e+6r��I��rއp8�vH�0%$�JA>��딸&��x _�gh�d!RE�x/a"�nU��z���Hό��p%(5W�t��0�fl�+�FEಟ��#����xU/�yʝ�/e�j�%���;-�6���JI��"����X'T��;y9O���}S8e�ed4E!i�jm����������\ٺL5&�0;��>��Wqɻq��Bh��(�`�+�5���.��*�/����

���*wo�q������X���׻1��Ks`��Eت1\Od��dDޥr�TYح��,�Z\�9>�	J*�d��O�5|\z����՞[�Ĝ�ޓ�(R2	W�s)�ƶ-��0Ch.�Z!Oyx#��- ?�����WElXKM!B��݃3��������ių��j�m������܀A��;-��9�F�4hl�4p<:	��4�w=f���o�6q��Hc��"3R<�l�]�}�=��C͔ɐQ��x�^��V���k�tIW��p;��$�N�
7z��-M�72����dQؖ�ܨT���it��^��}0���v�a��Ё�3	�it[Ք�.��_�㋕�f�@�R�ڽ`-H�k��rE�"�`��A��h�軴���C�洰F���"9��EF_vU��m>Q�O������ ���Ċ0�v�y�����_��䠏�:XL���4�Zb��s��$p���y��r��j�>	��L"1��L�qd����M�q����+��q2����B���c~ӹ ��d��ԯ�T�����R��� |�#(��t��;��^��>k�L��0 ����x;y����[?S�}�"�YL��7V1�Ѩ]�
�a���y/���ｚ&���*�� ?�%o��o��96�Y9�$�mdz4�F��1���f���P>#�6U\��0�#��#p�Vb�Co�2r�[���'\arRvˮ㇜�
��q�V$=��ۭ��n��C3掖��ҽ)�����
b��@66��r��/á���y8����>O�>���������4��?G�����OgZ      �   b   x�3�4�47�4�4�2�0�LcKK��1�m	�F���p���Q�Ǧ�
����0B�6"�d���	�cB�Q��B
�����7c��b���� d�K      �   f   x�eLI
1;ˏ)��w�srLH�2�0~��
�Z����1�{q{�sw���#Ӄ�Q�U�"�֚B�3�̾��+D1G���W�C��uҧ�/���*�      �   S   x�3�,�/-J,KIM�K,ɰ40qH�M���K�υJs���gqfJJFfvFbIbI*PY1X
�ؘ�$��B@Db���� N<"�     