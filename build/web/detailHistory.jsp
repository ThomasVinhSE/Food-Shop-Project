<%-- 
    Document   : billHistoory
    Created on : Jan 12, 2021, 1:01:07 PM
    Author     : Vinh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lịch Sử</title>
        <link href="framework/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="framework/css/font-awesome.min.css">
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <style>
            body {
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

            div#thumbnail {
                padding-left:0;
                padding-right:0;
                margin-bottom: 0;
                height: 220px;
                padding: 0;
                position: relative;
            }
            div#thumbnail img {
                height: -webkit-fill-available;
                width: fit-content;

            }
            div#thumbnail a {
                position: relative;
                margin-bottom:0;
                height: auto;
                opacity: 1;
                transform: scale(1);
                transition: 0.5s ease;
            }
            div#thumbnail a:hover {
                transform: scale(1.1);
                position:absolute;
                z-index: 1;
                opacity: 0.9;
                content:"ADD";
            }
            div#thumbnail a button {
                position:absolute;
                top:45%;
                left:35%;
                visibility: hidden;
                font-weight: bold;
                transition: 0.3s ease;
            }
            div#thumbnail a:hover button {
                visibility: visible;
            }

            div#detail{
                width: 100%;
                height: 100%;
            }
            div.panel-body span {
                display: inline-block;
                margin-bottom: 15px;
                font-size:15px;
            }
            img {
                background-size:cover;
                background-position-x: 0;
                background-position-y: 0;
                background-attachment: fixed;
            }
            a.thumbnail {
                position: relative;
                width:100%;
                height: inherit;
                margin-bottom:0;
                padding:2px;
            }
            div.blur {
                background:url('images/shopping.jpg') no-repeat fixed;
                background-size:cover;
                width:100vw;
                height:100vh;
                position:absolute;
                top:0;
                filter:blur(3px);
                z-index:-1;
            }
        </style>
        <script>
            var response = [];
            function passToObject(data)
            {
                var response = {};
                for (let tmp in data)
                {
                let value = data.[tmp];
                        response.[tmp] = value;
                }
            }
        </script>
        <script src="https://use.fontawesome.com/30e386e169.js"></script>
    </head>

    <body>
        <c:if test="${not empty sessionScope.ACCOUNT && sessionScope.ACCOUNT.role != 1}">



            <div class="blur"></div>
            <div class="container" style="z-index:10">

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
                            <li>
                                <a onClick="window.location.replace('http://localhost:8080/lab1')"href="#modal-id"><i class="fa fa-home" aria-hidden="true"></i> Trang chủ</a>
                            </li>
                            <li>
                                <a onClick="window.location.replace('http://localhost:8080/lab1/DispatcherServlet?btnAction=Search&txtSearchValue=' + '&txtCategory=' + '&txtMinPrice=' + '&txtMaxPrice=' + '&txtIndex=1');" href="#modal-id"><i class="fa fa-shopping-cart" aria-hidden="true"></i> Mua sắm</a>
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
                <div class="row" id="body" style="height:88vh;padding:0 3px 0 3px;">



                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12"  style="padding-bottom:18px;height: 148.7px;max-height: 149px;">


                        <h1 style="text-align:center;font-weight: 1000;color:rgb(235, 72, 0);font-size: 51px;;text-shadow: 0 50px 10px red;"><i class="fa fa-info" aria-hidden="true" style="color:black"></i> Detail</h1>


                    </div>

                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="items"style="max-width:1184px;max-height:440px;height: 440px;padding-left: 50px;padding-right: 50px;overflow-y:auto">



                        <div class="table-responsive" id="table">
                            <table class="table table-hover" style="color:black">
                                <thead style="background-color:rgba(255,255,255,1);">
                                    <tr>
                                        <th>No.</th>
                                        <th>Image</th>
                                        <th>Name</th>
                                        <th>Price</th>
                                        <th>Amount</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:set var="cart" value="${requestScope.DETAIL}"></c:set>
                                    <c:if test="${not empty cart}">
                                        <c:forEach var="item" items="${cart}" varStatus="counter">
                                            <tr style="max-height: 60px;background-color:rgba(255,255,255,0.5);">
                                                <td style="border-top:0px">${counter.count}</td>
                                                <td style="max-width: 0px;border-top:0px">
                                                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                                        <a type="button" class="thumbnail" href="${item.key.image}">
                                                            <img src="${item.key.image}">
                                                        </a>
                                                    </div>
                                                </td>
                                                <td style="border-top:0px">${item.key.name}</td>
                                                <td style="border-top:0px">${item.key.price}$</td>
                                                <td style="border-top:0px">${item.value}</td>
                                                <td style="border-top:0px">${String.format("%.2f",item.key.price*item.value)}$</td>

                                            </tr>
                                            <c:set var="total" value="${total+item.key.price*item.value}"></c:set>
                                        </c:forEach>
                                    </c:if>

                                </tbody>
                            </table>
                        </div>
                    </div>


                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" style="text-align:center;height:82px;max-height:82px;">
                        <hr/>
                        <h1 style="text-align:center;color:rgb(235, 72, 0);text-shadow: 0 -40px 10px red;">
                            <span class="label label-danger" style="font-size: 25px;">
                                Total : ${not empty total ? String.format("%.2f",total) : 0}$
                            </span>
                            <button type="button" onClick="window.location.replace('DispatcherServlet?btnAction=History&txtBillName=${param.txtBillName}&txtDate=${param.txtDate}')" style="font-size:20px;height:40px;width:193px;margin-top:2px;padding-top:5px;text-align: center;width: inherit" class="btn btn-success">Back <i class="fa fa-undo"></i></button>
                        </h1>
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
