<%-- 
    Document   : error
    Created on : Jan 10, 2021, 7:59:04 AM
    Author     : Vinh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trang Chủ</title>
        <link href="framework/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="framework/css/font-awesome.min.css">
        <style>
            body {
                background: url(./images/error.png) repeat 0 0 fixed;
                background-size:cover;
            }

            .container {
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

                                window.location.replace("http://localhost:8080/lab1/welcome.jsp");
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
                if (search === '' && param === undefined)
                {
                    swal("Warning!", "Can't search with empty product name", "error");
                    return;
                }
                if (hasUnicode(search))
                {
                    swal("Notice!", "Search value isn't unicode character", "error");
                    return;
                }
                search = search.trim();
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
                                            <div style="margin-top:5%">

                                                <div style="margin-top:5%;">
                                                    <button type="button" onClick="checkLogin('yes')" class="btn btn-primary">Đăng
                                                        nhập</button>
                                                </div>

                                            </div>
                                        </div>
                                        <input type="reset" id="form_reset"style="display:none;"/>
                                    </form>

                                </div>
                            </div>

                        </div>
                        <div class="modal-footer" style="text-align:center">

                            <input type="button" class="btn btn-danger"onClick="window.location.replace('https://accounts.google.com/o/oauth2/auth?client_id=946174400774-qb5n6hkf4fm3ni69io6p6s39vp39dsgh.apps.googleusercontent.com&scope=email&redirect_uri=http://localhost:8080/lab1/DispatcherServlet?btnAction=Login&response_type=code')"value="Đăng nhập bằng Google" />

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
                            <c:if test="${empty sessionScope.ACCOUNT}">
                                <a data-toggle="modal" href="#modal-id"><i class="fa fa-home" aria-hidden="true"></i> Trang chủ</a>
                            </c:if>
                            <c:if test="${not empty sessionScope.ACCOUNT && sessionScope.ACCOUNT.role != 1}">
                                <a href="/lab1"><i class="fa fa-home" aria-hidden="true"></i> Trang chủ</a>
                            </c:if>
                            <c:if test="${not empty sessionScope.ACCOUNT && sessionScope.ACCOUNT.role == 1}">
                                <a type="button" href='/lab1/DispatcherServlet?btnAction=Admin'><i class="fa fa-home" aria-hidden="true"></i> Trang Quản Lí</a>
                            </c:if>
                        </li>
                        <li>
                            <a onClick="window.location.replace('http://localhost:8080/lab1/DispatcherServlet?btnAction=Search&txtSearchValue=' + '&txtCategory=' + '&txtMinPrice=' + '&txtMaxPrice=' + '&txtIndex=1');" href="#modal-id"><i class="fa fa-shopping-cart" aria-hidden="true"></i> Mua sắm</a>
                        </li>
                        <li>

                            <c:if test="${not empty sessionScope.ACCOUNT}">
                                <div class="dropdown">
                                    <button class="btn btn-primary dropdown-toggle" style="padding:10px;height: 40px;border-radius: 0 4px 4px 0;" type="button" data-toggle="dropdown">
                                        <i class="fa fa-user" aria-hidden="true"></i> ${sessionScope.ACCOUNT.lastname}</button>
                                    <ul class="dropdown-menu" style="min-width: 120px">
                                        <li><a onClick="swal('Waiting', 'In update processing.....', 'warning');" type="button">Thông tin</a></li>
                                            <c:if test="${sessionScope.ACCOUNT.role != 1}">
                                            <li><a href="DispatcherServlet?btnAction=Cart">Giỏ hàng</a></li>
                                            <li><a href="DispatcherServlet?btnAction=History">Lịch sử</a></li>
                                            </c:if>
                                        <li><a href="DispatcherServlet?btnAction=Logout">Log out</a></li>
                                    </ul>
                                </div>
                            </c:if>
                            <c:if test="${empty sessionScope.ACCOUNT}">
                                <a data-toggle="modal" href="#modal-id"><i class="fa fa-sign-in" aria-hidden="true"></i> Đăng nhập</a>
                            </c:if>
                        </li>
                    </ul>


                </div>
            </div>

            <div class="row" id="body" style="height:88vh;padding:0 3px 0 3px;">



                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12"  style="padding-bottom:18px;height: 148.7px;max-height: 149px;">




                </div>

                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="items"style="max-width:1184px;max-height:440px;height: 440px;padding-left: 50px;padding-right: 50px;overflow-y:auto">



                    <c:if test="${not empty requestScope.MESSAGE}">
                        <h1 style="position: absolute;top:30%;left:15%;color:rgba(255,255,255,0.7)">${requestScope.MESSAGE}</h1>
                    </c:if>


                </div>
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" style="text-align:center;height:82px;max-height:82px;">


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
    </body>
</html>
