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
        <title>Admin</title>
        <link href="framework/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="framework/css/font-awesome.min.css">
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
            div#panel{
                background-image:url('images/background_1.jpg');
                border: 0.5px solid rgba(0,0,0,0.2);
                border-bottom-right-radius: 5px;
                border-bottom-left-radius: 5px;
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
                if (lastname === '' || role !== '1')
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
            function updateImage(evt)
            {

                var fileInput = evt.target;
                files = fileInput.files;
                // FileReader support
                if (FileReader) {
                    var fr = new FileReader();
                    fr.onload = function () {
                        document.getElementById('image').src = fr.result;
                    }
                    if (files[0] !== undefined)
                        fr.readAsDataURL(files[0]);
                }
            }
            function stopIncreasing(evt)
            {
                let value = evt.target.value;
                let reg = "-[0-9]*";
                var match = value.match(reg);
                if (match != null)
                    evt.target.value = '0';
            }
            function hasUnicode(str) {
                for (var i = 0; i < str.length; i++) {
                    if (str.charCodeAt(i) > 127)
                        return true;
                }
                return false;
            }
            function checkSubmit()
            {
                let name = document.getElementById('inputName').value;
                var valid = '';
                if (hasUnicode(name))
                {
                    valid += "Tên không chứa mã tiếng việt";
                }
                if (name === '')
                {
                    valid += "Điền tên sản phẩm";
                }
                let price = document.getElementById('inputPrice').value.trim().replace(/\s\s+/g, ' ');
                document.getElementById('inputPrice').value = price;
                var reg = '[0-9]*[.]?[0-9]*';
                let tmp1 = price.match(reg)[0];
                if (price.length !== tmp1.length || tmp1 === '')
                {
                    if (price === '')
                        document.getElementById('inputPrice').value = '0';
                    else
                        valid += "\nGiá phải là kiểu số";
                }
                if (valid !== '')
                {
                    swal('Warning!', valid, "warning");
                    return;
                }
                $('#form_create').submit();
            }

        </script>
    </head>
    <body> 
        <c:if test="${not empty sessionScope.ACCOUNT && sessionScope.ACCOUNT.role == 1}" >
            <div class="blur"></div>
            <div class="container">

                <div class="row" style="background-color: black;border-radius:0 10px 10px 0;">

                    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4" style="position:relative;left:-18px;padding-left:0;padding-right:0;height:40px;">
                        <form action="google.com" method="POST">
                            <div class="input-group">
                                <input id="txtSearchValue" value="   Create New Product" disabled="true" type="text" class="form-control" style="height: 40px;border-radius:30px 0 0 30px;font-weight:bold" id="exampleInputAmount" placeholder="eg. Food"/>
                                
                            </div>
                        </form>
                    </div>

                    <div class="col-xs-8 col-sm-8 col-md-8 col-lg-8" style="padding-left:0;padding-right:0">


                        <ul class="nav navbar-nav" style="float:right;">
                            <li style="background-color:rgb(255,255,255);">
                                <a type="button" ><i class="fa fa-home" aria-hidden="true"></i> Trang Quản Lí</a>
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
                                        <li><a href="DispatcherServlet?btnAction=Logout">Log out</a></li>
                                    </ul>
                                </div>
                            </li>
                        </ul>


                    </div>
                </div>
                <div class="row" style="height:85vh;position:relative;margin-top:30px">

                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="panel" style="height: 90%">
                        <form action="DispatcherServlet" method="POST" id="form_create"class="form-horizontal"  enctype="multipart/form-data">
                            <div class="form-group">
                                <legend style="text-align:center;font-weight:bold;font-size:30px;background-color:green;color:white">Thêm Sản Phẩm</legend>
                            </div>

                            <div class="form-group" style="height:inherit">

                                <div style="float:left;width:40%;margin-left:10%;">

                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <h3 class="panel-title" style="">Thông Tin Sản Phẩm</h3>
                                        </div>
                                        <div class="panel-body">
                                            <div class="form-group" style="">
                                                <label for="input" class="col-sm-1 control-label">Name: </label> <hr/>
                                                <div class="col-sm-10">
                                                    <input type="text" name="txtName" id="inputName" class="form-control" value="${param.txtName}" required="required" pattern="" title="">
                                                </div>
                                            </div>
                                            <div class="form-group" style="width:fit-content">
                                                <label for="input" class="col-sm-1 control-label">Category: </label> <hr/>
                                                <div class="col-sm-10">
                                                    <select name="txtCategory" id="input"style="width:100px;" class="form-control">
                                                        <option value="1" ${param.txtCategory == 1 ? 'selected' : ''}>Food</option>
                                                        <option value="2" ${param.txtCategory == 2 ? 'selected' : ''}>Drink</option>
                                                        <option value="3" ${param.txtCategory == 3 ? 'selected' : ''}>Vegetable</option>
                                                    </select>
                                                </div>
                                                </select>
                                            </div>
                                            <div class="form-group" style="width:fit-content">
                                                <label for="input" class="col-sm-1 control-label">Price: </label> <hr/>
                                                <div class="col-sm-10">
                                                    <input type="text" name="txtPrice" style="width:100px;" id="inputPrice" class="form-control" value="${empty param.txtPrice ? '0' : param.txtPrice}" required="required" pattern="" title="">
                                                </div>
                                            </div>
                                            <div class="form-group" style="width:auto">
                                                <label for="input" class="col-sm-1 control-label">Quantity: </label> <hr/>
                                                <div class="col-sm-10">
                                                    <input type="number" name="txtQuantity" onChange="stopIncreasing(event);"style="width:100px;" id="input" class="form-control" value="${empty param.txtQuantity ? '0' : param.txtQuantity}" required="required" pattern="" title="">
                                                    <input type="hidden" name="btnAction" value="Create" />
                                                    <button type="button" onClick="checkSubmit();" class="btn btn-success" style="position:absolute;top:0;right:18%" >Xác nhận</button>
                                                </div>
                                            </div>
                                            <div class="form-group" style="position:absolute;left:25%;bottom:25.3%">
                                                <label for="input" class="col-sm-1 control-label">Description: </label> <hr/>
                                                <div class="col-sm-10">
                                                    <textarea name="txtDescription" value="" id="input" class="form-control" style="width:215px;;max-width:215px;height: 150px"rows="3" required="required">${param.txtDescription}</textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>


                                </div>

                                <div style="float:right;width:30%;margin-right:10%;max-height:300px;max-width:600px" >
                                    <div class="panel panel-default">
                                        <div class="panel-heading" style="">
                                            <h3 class="panel-title" style="">Ảnh minh họa</h3>
                                        </div>
                                        <div class="panel-body" style="text-align:center">
                                            <a class="thumbnail" style="max-width:400px;height:300px;max-height:400px">
                                                <img id="image" src="./images/noImage.png" style="width:100%;height:-webkit-fill-available;max-height: inherit;object-position: top center" alt=""/>
                                            </a> <br/>
                                            <input style="margin-top:15px"type="file" onClick="document.getElementById('image').src = './images/noImage.png';" onChange="updateImage(event)" title="2" value="" size="chars" name="txtFile" id="file" accept="image/*" />
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </form>
                    </div>


                    <div style="position:absolute;bottom:0px;text-align:center;width:100%;" >
                        <button onClick="window.location.replace('/lab1/DispatcherServlet?btnAction=Update&txtCategory=All&txtStatus=1&txtIndex=1')" class="btn btn-success"style="font-size:15px" ><i class="fa fa-wrench"></i> Cập Nhật </button>
                    </div>
                </div>

            </div>
        </c:if>
        <c:if test="${empty sessionScope.ACCOUNT || sessionScope.ACCOUNT.role != 1}">
            <c:import url="error.jsp"></c:import>

            <c:if test="${not empty sessionScope.ACCOUNT && sessionScope.ACCOUNT.role != 1}">
                <h1 style="position: absolute;top:40%;left:30%;color:rgba(255,255,255,0.7)">Quyền admin để truy cập trang này</h1>
            </c:if>
            <c:if test="${empty sessionScope.ACCOUNT}">
                <h1 style="position: absolute;top:40%;left:25%;color:rgba(255,255,255,0.7)">Bạn không được phép truy cập khi chưa đăng nhập</h1>
            </c:if>

        </c:if>                      
        <!-- jQuery -->
        <script src="framework/js/jquery-3.2.1.min.js"></script>
        <!-- Bootstrap JavaScript -->
        <script src="framework/js/bootstrap.min.js"></script>
    </body>
</html>
