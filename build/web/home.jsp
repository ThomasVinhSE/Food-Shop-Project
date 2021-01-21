<%-- 
    Document   : welcome
    Created on : Jan 5, 2021, 4:03:42 PM
    Author     : Vinh
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trang Home</title>
        <link href="framework/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="framework/css/font-awesome.min.css">
        <style>
            body {
                background: url(./images/shopping.jpg) repeat 0 0 fixed;
                background-size:cover;
            }

            .container {
                background-image: url(./images/background.jpg) no-repeat;
                background-color: #fff;
                margin-top: 1%;
                margin-bottom:1%;
                padding: 0 4px 0 4px;
                font-size: 15px;
            }

            .nav li a {
                padding: 10px;
            }

            div.item img {
                width: 100%;
                object-fit: contain;
            }

            div.carousel-caption {
                margin-bottom: 15%;
            }

            div.item {
                height: inherit;
            }

            .modal {
                text-align: center;
            }

            .modal:before {
                content: '';
                display: inline-block;
                height: 100%;
                vertical-align: middle;
            }

            .modal-dialog {
                display: inline-block;
                margin: 0 auto;
                vertical-align: middle;
            }

            .modal .modal-content {
                padding: 20px 20px 20px 20px;
                animation-name: modal-animation;
                animation-duration: 0.5s;
            }

            @keyframes modal-animation {
                from {
                    top: -100px;
                    opacity: 0;
                }

                to {
                    top: 0px;
                    opacity: 1;
                }
            }

        </style>
        <script src="https://use.fontawesome.com/30e386e169.js"></script>
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script>
            async function postData(url = '', data = {}) {
                // Default options are marked with *
                const response = await fetch(url, {
                    method: 'POST', // *GET, POST, PUT, DELETE, etc.
                    mode: 'same-origin', // no-cors, *cors, same-origin
                    cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
                    credentials: 'same-origin', // include, *same-origin, omit
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        // 'Content-Type': 'application/x-www-form-urlencoded',
                        redirect: 'follow', // manual, *follow, error
                        referrerPolicy: 'no-referrer', // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
                        body: '' // body data type must match "Content-Type" header
                    }});
                return response; // parses JSON response into native JavaScript objects
            }
            var username = '';
            var password = '';
            var category = '';
            function passUsername(name)
            {
                username = name;
            }
            function passPassword(pass)
            {
                password = pass;
            }

            function checkLogin(param)
            {
                console.log(category);
                const data = {txtUsername: username, txtPassword: password};
                if (data.txtUsername === '' && data.txtPassword === '')
                {
                    swal("Sorry!", "Please fill at least one field!", "warning");
                    return;
                }
                postData('http://localhost:8080/lab1/DispatcherServlet?' +
                        'btnAction=Login&txtUsername=' +
                        data.txtUsername +
                        '&txtPassword=' + data.txtPassword, {})
                        .then(data => {
                            if (data.status === 401)
                            {
                                failLogin();
                            }// JSON data parsed by `data.json()` call
                            else
                            {
                                if (category !== '')
                                {
                                    searchObject = {txtCategory: category};
                                    makeSearch(param);
                                    return;
                                }

                                window.location.replace("http://localhost:8080/lab1/");
                            }
                        });
            }
            function failLogin()
            {
                swal("Sorry!", "Not exits account in Hana Shop", "error");
            }
        </script>
        <script>
            var searchObject = {};
            function change(name, value)
            {
                searchObject[name] = value;
            }
            function hasUnicode(str) {
                for (var i = 0; i < str.length; i++) {
                    if (str.charCodeAt(i) > 127)
                        return true;
                }
                return false;
            }
            function makeSearch(param)
            {
                let search = searchObject.txtSearchValue === undefined ? '' : searchObject.txtSearchValue;
                if (hasUnicode(search))
                {
                    swal("Notice!", "Search value isn't unicode character", "error");
                    return;
                }
                search = search.trim().replace(/\s\s+/g, ' ');
                let category = searchObject.txtCategory === undefined ? '' : searchObject.txtCategory;
                let min = searchObject.txtMinPrice === undefined ? '' : searchObject.txtMinPrice;
                let max = searchObject.txtMaxPrice === undefined ? '' : searchObject.txtMaxPrice;
                window.location.replace("http://localhost:8080/lab1/DispatcherServlet?btnAction=Search&txtSearchValue=" + search + "&txtCategory=" + category + "&txtMinPrice=0" + "&txtMaxPrice=0&txtIndex=1");
            }
        </script>
        
    </head>
    <body>  
        <div class="container">
            <div class="modal fade" id="modal-id">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h3 class="modal-title">
                                <i class="fa fa-sign-in fa-2x" aria-hidden="true"></i>
                            </h3>
                        </div>
                        <div class="modal-body">

                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <h3 class="panel-title">
                                        Hana Shop
                                    </h3>
                                </div>
                                <div class="panel-body">

                                    <form action="DispatcherServlet" method="POST" id="login">

                                        <div class="form-group">
                                            <label for="">Username</label>
                                            <input type="text" class="form-control" onChange="passUsername(this.value)"  name="txtUsername"
                                                   placeholder="admin">
                                            <label for="">Password</label>
                                            <input type="password" onChange="passPassword(this.value)" class="form-control"  name="txtPassword"
                                                   placeholder="admin">
                                            <div style="margin-top:5%;" id="google">
                                                <button type="button" onClick="checkLogin('yes')" class="btn btn-primary">Đăng  
                                                    nhập</button>
                                            </div>
                                        </div>
                                        <input type="reset" id="form_reset"style="display:none;"/>
                                    </form>

                                </div>
                            </div>

                        </div>
                        <div class="modal-footer" style="text-align:center">
                            <input type="button" class="btn btn-danger"onClick="window.location.replace('https://accounts.google.com/o/oauth2/auth?client_id=1066485509181-g226gik0baf97igo1p4pn1o405bivm20.apps.googleusercontent.com&scope=email&redirect_uri=http://localhost:8080/lab1/DispatcherServlet?btnAction=Login&response_type=code')"value="Đăng nhập bằng Google" />

                            <!-- <button type="button" class="btn btn-default" data-dismiss="modal">Close</button> -->
                        </div>
                    </div>
                </div>
            </div>
            <div class="row" style="background-color: black;border-radius:0 10px 10px 0">

                <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4" style="position:relative;left:-18px;padding-left:0;padding-right:0;height:40px;">
                    <form action="google.com" method="POST">
                        <div class="input-group">
                            <input onChange="change('txtSearchValue', this.value)"type="text" class="form-control" style="height: 40px;border-radius:30px 0 0 30px;" id="exampleInputAmount" placeholder="eg. Food"/>
                            <span class="input-group-btn">
                                <button onClick="makeSearch()" type="button"style="height: 40px;" class="btn btn-primary"><span class="fa fa-search"></span>
                                    Tìm</button>
                            </span>
                        </div>
                    </form>
                </div>

                <div class="col-xs-8 col-sm-8 col-md-8 col-lg-8" style="padding-left:0;padding-right:0">


                    <ul class="nav navbar-nav" style="float:right;">
                        <li>
                            <a data-toggle="modal" href="#modal-id"><i class="fa fa-home" aria-hidden="true"></i> Trang chủ</a>
                        </li>
                        <li>
                            <a onClick="window.location.replace('http://localhost:8080/lab1/DispatcherServlet?btnAction=Search&txtSearchValue=' + '&txtCategory=' + '&txtMinPrice=' + '&txtMaxPrice=' + '&txtIndex=1');" href="#modal-id"><i class="fa fa-shopping-cart" aria-hidden="true"></i> Mua sắm</a>
                        </li>
                        <li>

                            <a data-toggle="modal" href="#modal-id"><i class="fa fa-sign-in" aria-hidden="true"></i> Đăng nhập</a>
                        </li>
                    </ul>


                </div>
            </div>

            <div class="row" style="height:88vh">

                <div id="carousel-id" class="carousel slide" data-ride="carousel" style="margin:0 auto;width:99%;height: inherit;">
                    <ol class="carousel-indicators">
                        <li data-target="#carousel-id" data-slide-to="0" class=""></li>
                        <li data-target="#carousel-id" data-slide-to="1" class=""></li>
                        <li data-target="#carousel-id" data-slide-to="2" class="active"></li>
                    </ol>
                    <div class="carousel-inner" style="height:inherit;object-fit: cover">
                        <div class="item">
                            <img src="./images/food/bread2.jpg" style="max-height: 774px;object-fit: cover;object-position: center">
                            <div class="container">
                                <div class="carousel-caption">
                                    <h1>Đồ ăn</h1>
                                    <p><span class="label label-warning"style="font-size:15px;">Hàng hot</span></p>
                                    <p><a class="btn btn-lg btn-danger" onClick="category = 'Food';" data-toggle="modal" href="#modal-id"><i class="fa fa-money" aria-hidden="true"></i> Mua ngay!</a></p>
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <img src="./images/drink/cocktail.jpg" style="max-height: 774px;object-fit: cover;object-position: center">
                            <div class="container">
                                <div class="carousel-caption">
                                    <h1>Nước Uống</h1>
                                    <p><span class="label label-warning"style="font-size:15px;">Hàng hot</span></p>
                                    <p><a class="btn btn-lg btn-danger" onClick="category = 'Drink';"data-toggle="modal" href="#modal-id"><i class="fa fa-money" aria-hidden="true"></i> Mua ngay!</a></p>
                                </div>
                            </div>
                        </div>
                        <div class="item active">
                            <img src="./images/vegetable/vegetable5.jpg">
                            <div class="container">
                                <div class="carousel-caption">
                                    <h1>Rau quả</h1>
                                    <p><span class="label label-warning"style="font-size:15px;">Hàng hot</span></p>
                                    <p><a class="btn btn-lg btn-danger"onClick="category = 'Vegetable';" data-toggle="modal" href="#modal-id"><i class="fa fa-money" aria-hidden="true"></i> Mua ngay!</a></p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <a class="left carousel-control" href="#carousel-id" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span></a>
                    <a class="right carousel-control" href="#carousel-id" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span></a>
                </div>

            </div>

        </div>

        <!-- jQuery -->
        <script src="framework/js/jquery-3.2.1.min.js"></script>
        <!-- Bootstrap JavaScript -->
        <script src="framework/js/bootstrap.min.js"></script>
        <script>
                                        $('#modal-id').on('hidden.bs.modal', function () {
                                            document.getElementById("form_reset").click();

                                            category = '';
                                        });
        </script>
    </body >
</html>
