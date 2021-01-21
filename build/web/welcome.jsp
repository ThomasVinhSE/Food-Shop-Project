<%-- 
    Document   : welcome
    Created on : Jan 7, 2021, 10:57:37 AM
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
                background: url(./images/shopping.jpg) repeat 0 0 fixed;
            }

            .container {
                background-image: url(./images/background.jpg) no-repeat;
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
            var searchObject = {};
            function change(name, value)
            {
                searchObject[name] = value;
                makeSearch();
            }
            function welcome()
            {
                let lastname = '${sessionScope.ACCOUNT.lastname}';
                let role = '${sessionScope.ACCOUNT.role}';
                if (lastname === '' || role === '1')
                    return;
                swal("Congrats!", "Welcome ${sessionScope.ACCOUNT.lastname} to Hana Shop", "success");
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
                search = search.trim().replace( /\s\s+/g, ' ' );
                if (hasUnicode(search))
                {
                    swal("Notice!", "Search value isn't unicode character", "error");
                    return;
                }
                let category = searchObject.txtCategory === undefined ? '' : searchObject.txtCategory;
                let min = searchObject.txtMinPrice === undefined ? '' : searchObject.txtMinPrice;
                let max = searchObject.txtMaxPrice === undefined ? '' : searchObject.txtMaxPrice;
                window.location.replace("http://localhost:8080/lab1/DispatcherServlet?btnAction=Search&txtSearchValue=" + search + "&txtCategory=" + category + "&txtMinPrice=0" + "&txtMaxPrice=0&txtIndex=1");
            }
        </script>
    </head>
    <body onLoad="welcome();"> 
        <c:if test="${not empty sessionScope.ACCOUNT && sessionScope.ACCOUNT.role != 1}" >
            <div class="container">

                <div class="row" style="background-color: black;border-radius:0 10px 10px 0;">

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
                            <li style="background-color:rgb(255,255,255);">
                                <a type="button" ><i class="fa fa-home" aria-hidden="true"></i> Trang chủ</a>
                            </li>
                            <li>
                                <a onClick="window.location.replace('http://localhost:8080/lab1/DispatcherServlet?btnAction=Search&txtSearchValue=' + '&txtCategory=' + '&txtMinPrice=' + '&txtMaxPrice=' + '&txtIndex=1');" href="#modal-id" ><i class="fa fa-shopping-cart" aria-hidden="true"></i> Mua sắm</a>
                            </li>
                            <li>
                                <div class="dropdown">
                                    <button class="btn btn-primary dropdown-toggle" style="padding:10px;height: 40px;border-radius: 0 4px 4px 0;" type="button" data-toggle="dropdown">
                                        <i class="fa fa-user" aria-hidden="true"></i> ${sessionScope.ACCOUNT.lastname}</button>
                                    <ul class="dropdown-menu" style="min-width: 120px">
                                        <li><a onClick="swal('Waiting', 'In update processing.....', 'warning');" type="button">Thông tin</a></li>
                                        <li><a href="DispatcherServlet?btnAction=Cart">Giỏ hàng</a></li>
                                        <li><a href="DispatcherServlet?btnAction=History">Lịch sử</a></li>
                                        <li><a href="DispatcherServlet?btnAction=Logout">Log out</a></li>
                                    </ul>
                                </div>
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
                                        <p><a class="btn btn-lg btn-danger" onClick="category = 'Food';searchObject = {txtCategory: category};makeSearch(1);" ><i class="fa fa-money" aria-hidden="true"></i> Mua ngay!</a></p>
                                    </div>
                                </div>
                            </div>
                            <div class="item">
                                <img src="./images/drink/cocktail.jpg" style="max-height: 774px;object-fit: cover;object-position: center">
                                <div class="container">
                                    <div class="carousel-caption">
                                        <h1>Nước Uống</h1>
                                        <p><span class="label label-warning"style="font-size:15px;">Hàng hot</span></p>
                                        <p><a class="btn btn-lg btn-danger" onClick="category = 'Drink';searchObject = {txtCategory: category};makeSearch(1);"><i class="fa fa-money" aria-hidden="true"></i> Mua ngay!</a></p>
                                    </div>
                                </div>
                            </div>
                            <div class="item active">
                                <img src="./images/vegetable/vegetable5.jpg">
                                <div class="container">
                                    <div class="carousel-caption">
                                        <h1>Rau quả</h1>
                                        <p><span class="label label-warning"style="font-size:15px;">Hàng hot</span></p>
                                        <p><a class="btn btn-lg btn-danger"onClick="category = 'Vegetable';searchObject = {txtCategory: category};makeSearch(1);" ><i class="fa fa-money" aria-hidden="true"></i> Mua ngay!</a></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <a class="left carousel-control" href="#carousel-id" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span></a>
                        <a class="right carousel-control" href="#carousel-id" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span></a>
                    </div>

                </div>

            </div>
        </c:if>
        <c:if test="${empty sessionScope.ACCOUNT || sessionScope.ACCOUNT.role == 1}">
            <c:import url="error.jsp"></c:import>

            <c:if test="${sessionScope.ACCOUNT.role == 1}">
                <h1 style="position: absolute;top:40%;left:30%;color:rgba(255,255,255,0.7)">Role admin không thể truy cập trang này</h1>
                <button onClick="window.location.replace('DispatcherServlet?btnAction=Admin')" style="position: absolute;top:50%;left:48%;color:rgba(255,255,255,1)" class="btn btn-success">Quay lại</button>
            </c:if>
            <c:if test="${sessionScope.ACCOUNT.role != 1}">
                <h1 style="position: absolute;top:40%;left:25%;color:rgba(255,255,255,0.7)">Bạn không được phép truy cập khi chưa đăng nhập</h1>
            </c:if>

        </c:if>                     
        <!-- jQuery -->
        <script src="framework/js/jquery-3.2.1.min.js"></script>
        <!-- Bootstrap JavaScript -->
        <script src="framework/js/bootstrap.min.js"></script>
    </body>
</html>
