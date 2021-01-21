<%-- 
    Document   : search.jsp
    Created on : Jan 8, 2021, 5:36:28 PM
    Author     : Vinh
--%>

<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin</title>
        <link href="framework/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="framework/css/font-awesome.min.css">
       <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
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
            div#navtop {
                /*                background-image: linear-gradient(to top, #fff, rgba(252, 227, 197));
                                background-repeat: repeat-x;*/
                border: 1px solid #d4d4d4;
                border-radius: 4px 4px 3px 3px;
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
            div#items h1{
                background-image: url('./images/notfound.jpg');
                background-position: center;
                background-repeat: no-repeat;
                background-size: auto;
                margin-top:0;
                margin-bottom: 0;
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
            div#items h1{
                background-image: url('./images/notfound.jpg');
                background-position: center;
                background-repeat: no-repeat;
                background-size: auto;
                margin-top:0;
                margin-bottom: 0;
            }
        </style>
        <script src="https://use.fontawesome.com/30e386e169.js"></script>
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script>
            function updateImage(evt)
            {

                var fileInput = evt.target;
                files = fileInput.files;
                // FileReader support
                if (FileReader) {
                    var fr = new FileReader();
                    fr.onload = function () {
                        document.getElementById('modal_img').src = fr.result;
                    }
                    if (files[0] !== undefined)
                        fr.readAsDataURL(files[0]);
                }
            }
            function hasUnicode(str) {
                for (var i = 0; i < str.length; i++) {
                    if (str.charCodeAt(i) > 127)
                        return true;
                }
                return false;
            }
            function minus()
            {
                var inputText = document.getElementById("quantity");
                if (parseInt(inputText.value) >= 1)
                {
                    inputText.value = parseInt(inputText.value) - 1;
                    document.getElementById('amount').value = inputText.value;
                }
            }
            function plus()
            {
                var inputText = document.getElementById("quantity");
                inputText.value = parseInt(inputText.value) + 1;
                document.getElementById('amount').value = inputText.value;
            }
            function makeSearch2()
            {
                let txtSearchValue = document.getElementById("txtSearchValue").value;
                let search = txtSearchValue === undefined ? '' : txtSearchValue;
                if (search === '')
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
                window.location.replace("http://localhost:8080/lab1/DispatcherServlet?btnAction=Search&txtSearchValue=" + search + "&txtCategory=" + "&txtMinPrice=0" + "&txtMaxPrice=0&txtIndex=1");
            }
            function makeSearch(searchNew)
            {

                let categoryTmp = document.getElementById('txtCategory').value;
                let status = document.getElementById('txtStatus').value;
                let category = categoryTmp === undefined ? '' : categoryTmp;

                checkValid(category, status, searchNew);
            }
            var index = 1;
            var size = 0;
            function checkValid(category, status, searchNew)
            {
                if (searchNew === 'yes')
                    index = 1;
                window.location.replace("http://localhost:8080/lab1/DispatcherServlet?btnAction=Update&txtCategory=" + category + "&txtStatus=" + status + "&txtIndex=" + index);
            }

        </script>
        <script>

            function chaneIndex(param)
            {
                if (index === param)
                {
                    return;
                }
                if (param === -1)
                {
                    index = index - 1;
                    if (index < 1)
                    {
                        index++;
                        return;
                    }
                } else if (param === -2)
                {
                    index = index + 1;
                    if (index > size)
                    {
                        index--;
                        return;
                    }
                } else
                    index = param;
                makeSearch();
            }
            var index = 1;
            function detail(data)
            {
                const img = document.getElementById("modal_img");
                const name = document.getElementById("inputName");
                const title = document.getElementById("modal_title");
                const type = document.getElementById("inputCategory");
                const price = document.getElementById("inputPrice");
                const description = document.getElementById("inputDescription");
                const productId = document.getElementById("productId");
                const quantity = document.getElementById("quantity");

                img.src = data.img;
                title.innerHTML = data.title;
                var option = 0;
                switch (data.type)
                {
                    case 'Food':
                        option = 0;
                        break;
                    case 'Drink':
                        option = 1;
                        break;
                    case 'Vegetable':
                        option = 2;
                        break;
                }
                name.value = data.title;
                type.options[option].selected = true;
                price.value = data.price;
                description.value = data.content;
                quantity.value = (data.quantity <= 0 ? 0 : data.quantity);
                productId.value = data.id;
                document.getElementById("amount").value = quantity.value;
            }
            function focusTag()
            {
                let a = document.getElementById(index);
                a.style.backgroundColor = "rgb(243, 217, 104)";
            }
            function clickTag(param)
            {
                index = param;
                size = document.getElementsByName("paging").length;
                if (index > size)
                {
                    index = 1;
                }
                focusTag();
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
            function restoreProduct()
            {
                $.confirm({
                    title: 'Xác định bán sản phẩm này?',
                    content: 'Tự động close dialog in 5s',
                    autoClose: 'Hủy|5000',
                    buttons: {
                        Delete: {
                            text: 'Xóa',
                            action: function () {
                                const id = document.getElementById('productId').value;
                                const category = document.getElementById('txtCategory').value;
                                const status = document.getElementById('txtStatus').value;

                                window.location.replace('DispatcherServlet?btnAction=Restore&txtProductId=' + id + '&txtCategory=' + category + '&txtStatus=' + status + '&txtIndex=1');
                            }
                        },
                        Hủy: function () {
//                            $.alert('action is canceled');
                        }
                    }
                });
            }
            function deleteProduct()
            {
                $.confirm({
                    title: 'Ngừng bán sản phẩm này?',
                    content: 'Tự động close dialog in 5s',
                    autoClose: 'Hủy|5000',
                    buttons: {
                        Delete: {
                            text: 'Xóa',
                            action: function () {
                                const id = document.getElementById('productId').value;
                                const category = document.getElementById('txtCategory').value;
                                const status = document.getElementById('txtStatus').value;

                                window.location.replace('DispatcherServlet?btnAction=Delete&txtProductId=' + id + '&txtCategory=' + category + '&txtStatus=' + status + '&txtIndex=1');
                            }
                        },
                        Hủy: function () {
//                            $.alert('action is canceled');
                        }
                    }
                });
            }
        </script>
    </head>
    <body onLoad="clickTag(${param.txtIndex})">
        <c:if test="${not empty sessionScope.ACCOUNT && sessionScope.ACCOUNT.role == 1}" >

            <div class="modal fade" id="modal-id">
                <div class="modal-dialog" style="width:auto;z-index:20;margin: 0 auto;padding: 5% 20% 0 20%;">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title"><code>Thông Tin</code></h4>
                        </div>
                        <div class="modal-body">

                            <div class="row" style="height: 50vh;">

                                <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6" style="height: inherit;">
                                    <img src="./images/food/chicken.jpg" id="modal_img" style="max-width: 800px;max-height: 400px;width:100%;height:inherit;object-fit: cover;"/>
                                </div>

                                <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6" style="text-align: start;font-size:100%;height:inherit">

                                    <div class="panel panel-info"style="position:relative;height:inherit">
                                        <div class="panel-heading">
                                            <h3 class="panel-title" id="modal_title"style="text-align:center">Chicken</h3>
                                        </div>
                                        <div class="panel-body" style="height:inherit">
                                            <form action="DispatcherServlet" method="POST" id="form_create"  enctype="multipart/form-data">
                                                <input type="hidden" name="txtProductId" id="productId" />
                                                <div class="form-group" style="">
                                                    <label for="input" class="col-sm-12 control-label">Name: </label> <br/>
                                                    <div class="col-sm-6">
                                                        <input type="text" name="txtName" id="inputName" class="form-control" value="" required="required" pattern="" title="">
                                                    </div>
                                                </div>
                                                <div class="form-group" style="width:fit-content">
                                                    <label for="input" class="col-sm-12 control-label">Category: </label>
                                                    <div class="col-sm-6">
                                                        <select name="txtCategory" id="inputCategory"style="width:100px;" class="form-control">
                                                            <option value="1">Food</option>
                                                            <option value="2">Drink</option>
                                                            <option value="3">Vegetable</option>
                                                        </select>
                                                    </div>

                                                </div>
                                                <div class="form-group" style="width:fit-content">
                                                    <label for="input" class="col-sm-12 control-label">Price: </label>
                                                    <div class="col-sm-6">
                                                        <input type="text" name="txtPrice" style="width:100px;" id="inputPrice" class="form-control" value="0" required="required" pattern="" title="">
                                                    </div>
                                                </div>
                                                <div class="form-group" style="position:absolute;left:50%;bottom:35%">
                                                    <label for="input" class="col-sm-12 control-label">Description: </label>
                                                    <div class="col-sm-6">
                                                        <textarea name="txtDescription" id="inputDescription" class="form-control" style="width:215px;;max-width:180px;height: 150px"rows="3" required="required"></textarea>
                                                    </div>
                                                </div>
                                                <div class="form-group" style="width:fit-content;">
                                                    <label for="input" class="col-sm-12 control-label">Quantity: </label>
                                                    <div class="col-sm-6" style="padding-left:0">
                                                        <div class="col-sm-2" style="z-index:10"> 
                                                            <button onClick="minus()"  type="button"><i class="fa fa-minus-circle"></i></button>
                                                        </div>
                                                        <div class="col-sm-2"> 
                                                            <input type="text" id="quantity" disabled="true" value="1" style="width: 25px;text-align: center;"></input>
                                                            <input type="hidden" id="amount" name="txtQuantity" value="1" />
                                                        </div>
                                                        <div class="col-sm-2"> 
                                                            <button onClick="plus()" type="button"><i class="fa fa-plus-circle"></i></button>
                                                        </div>

                                                    </div>
                                                </div>
                                                <input type="file" onClick="document.getElementById('modal_img').src = '';" onChange="updateImage(event)" title="2" value="" size="chars" name="txtFile" id="file" accept="image/*" style="position:absolute; top:70%;left:65%" />
                                                <input type="hidden" name="btnAction" value="Create" />
                                                <input type="hidden" name="ForUpdate" value="" />
                                                <input type="hidden" name="txtIndex" value="1" />
                                                <input type="hidden" name="txtStatus" value="${param.txtStatus}" />
                                                <input type="hidden" name="txtCategory2" value="${param.txtCategory}" />
                                                <div style="position:absolute;bottom:0;left:30%">
                                                    <c:if test="${not empty sessionScope.ACCOUNT && sessionScope.ACCOUNT.role == 1}">
                                                        <c:if test="${param.txtStatus == 1}">
                                                        <br/>
                                                        <button type="button" onClick="checkSubmit();" class="btn btn-danger"><i class="fa fa-database"></i> Cập nhật</button>
                                                        <button type="button" 
                                                                onClick="deleteProduct();" 
                                                                class="btn btn-danger">
                                                            <i class="fa fa-window-close">

                                                            </i> Ngừng bán
                                                        </button>
                                                        </c:if>
                                                        <c:if test="${param.txtStatus == 0}">
                                                        <br/>
                                                        <button type="button" onClick="checkSubmit();" class="btn btn-danger"><i class="fa fa-database"></i> Cập nhật</button>
                                                        <button type="button" 
                                                                onClick="restoreProduct();" 
                                                                class="btn btn-danger">
                                                            <i class="fa fa-window-close">

                                                            </i> Bán lại
                                                        </button>
                                                        </c:if>
                                                    </c:if>

                                                </div>
                                            </form>
                                        </div>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="blur"></div>
            <div class="container">

                <div class="row" style="background-color: black;border-radius:0 10px 10px 0">

                    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4" style="position:relative;left:-18px;padding-left:0;padding-right:0;height:40px;">
                        <div class="input-group">
                            <input id="txtSearchValue" value="   Update / Delete Product" disabled="true" type="text" class="form-control" style="height: 40px;border-radius:30px 0 0 30px;font-weight:bold" id="exampleInputAmount" placeholder="eg. Food"/>
                        </div>
                    </div>

                    <div class="col-xs-8 col-sm-8 col-md-8 col-lg-8" style="padding-left:0;padding-right:0">

                        <ul class="nav navbar-nav" style="float:right;">
                            <li style="background-color:rgb(255,255,255);">
                                <a type="button" ><i class="fa fa-home" aria-hidden="true"></i> Trang Quản Lí</a>
                            <li>
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

                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="panel" style="height: 90%;position:relative">

                        <h1 style="position:absolute;top:-4%;background-color:green;width: 100.1%;left:-1px;height:20px"></h1>
                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12"  >


                            <form action="" method="POST" class="form-inline" style="text-align:center;padding-top:30px">

                                <div class="form-group">

                                    <span class="label label-warning" style="margin-right:10%">Thể loại</span><span style="margin-right:15%"class="label label-warning">Trạng thái</span> <br/>
                                    <select id="txtCategory" name="txtCategory"  class="form-control" style="margin-bottom:10px;">
                                        <option value="All" >-- Tất Cả --</option>
                                        <option value="Food" ${empty param.txtCategory2 ? param.txtCategory.equals('Food') ? 'selected':'': param.txtCategory2.equals('Food') ? 'selected':'' }>Food</option>
                                        <option value="Drink" ${empty param.txtCategory2 ? param.txtCategory.equals('Drink') ? 'selected':'': param.txtCategory2.equals('Drink') ? 'selected':'' }>Drink</option>
                                        <option value="Vegetable"${empty param.txtCategory2 ? param.txtCategory.equals('Vegetable') ? 'selected':'': param.txtCategory2.equals('Vegetable') ? 'selected':'' } >Vegetable</option>
                                    </select>
                                    <select id="txtStatus" name="txtStatus"  class="form-control" style="margin-bottom:10px;">
                                        <option value="1" >Hoạt động</option>
                                        <option value="0" ${param.txtStatus.equals('0') ? 'selected':''}>Ngừng Bán</option>
                                    </select>
                                    <button onClick="makeSearch('yes')" type="button" style="margin-bottom:10px;margin-left:10px" class="btn btn-success"><span class="fa fa-search"></span>
                                        Tìm</button>
                                    <div style="width:551px;height:34px;max-width: 551px;max-height:34px">

                                    </div>
                                </div>

                            </form>

                        </div>

                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="items"style="max-width:1184px;max-height:440px;height: 440px;padding-left: 0;padding-right: 0;">
                            <c:if test="${not empty requestScope.LIST}">
                                <c:forEach var="item" items="${requestScope.LIST}">
                                    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4" id="thumbnail" >

                                        <a class="thumbnail" type="button">
                                            <img src="${item.image}" alt="">
                                            <button class="btn btn-primary" onClick="detail({id: '${item.productId}', img: '${item.image}', title: '${item.name}', type: '${item.passCategory()}', content: '${item.description}', price: '${item.price}', quantity: '${item.quantity}', date: '${item.passTime()}'})"data-toggle="modal" href='#modal-id'>Cập nhật Info</button>
                                        </a>

                                    </div>

                                </c:forEach>
                            </c:if>
                            <c:if test="${empty requestScope.LIST}">
                                <h1 style="max-height: inherit;height: inherit"></h1>
                                <%
                                    request.setAttribute("SIZE", 0);
                                %>
                            </c:if>
                        </div>

                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" style="z-index:10;text-align: center">


                            <ul class="pagination" style="">
                                <li><a onClick="chaneIndex(-1)" >&laquo;</a></li>
                                    <%
                                        List list = (List) request.getAttribute("LIST");
                                        int size = (Integer) request.getAttribute("SIZE");
                                        int count = 0;
                                        int index = 2; %>
                                <li><a onClick="chaneIndex(1)"id="1" name="paging" >1</a></li>
                                    <%    for (int i = 0; i < size; i++) {
                                            count++;
                                            if (count > 6) {%>
                                <li><a onClick="chaneIndex(<%= index%>)"id="<%= index%>" name="paging"><%= index%></a></li>
                                    <%
                                                count = 1;
                                                index++;
                                            }
                                        }
                                    %>
                                <li><a onClick="chaneIndex(-2)" >&raquo;</a></li>
                            </ul>
                        </div>
                        <button onClick="window.location.replace('/lab1/DispatcherServlet?btnAction=Admin')"class="btn btn-success" style="font-size:15px;position:absolute;left:0;bottom:-8.5%;z-index:12"><i class="fa fa-plus"></i> Tạo Mới </button>
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
        <script>
                            $('#modal-id').on('show.bs.modal', function () {
                                // Load up a new modal...
                                $('#modal-id').modal('hide');
                            })
                            $('#modal-id').on('hide.bs.modal', function () {
                                isAddCart = false;
                            })
        </script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>
    </body>
</html>

