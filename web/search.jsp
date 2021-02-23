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
        <title>Tìm Kiếm</title>
        <link href="framework/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="framework/css/font-awesome.min.css">
        <style>
            body {
                background: url(./images/shopping.jpg) no-repeat 0 0 fixed ;
                background-size: cover;
                position:relative;
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
                max-height: 220px;
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
            div#nav-left{
                background-image: url('images/background_1.jpg');
                position:absolute;
                width: 10%;
                height: 90vh;
                left:0;
                top:8%;

            }
            div#nav-right{
                background-image: url('images/background_1.jpg');
                position:absolute;
                width: 10%;
                height: 90vh;
                top:8%;
                right:0;
            }

            div#nav-left a.decor:hover{
                opacity:0.1;
            }
            div#nav-right a.decor:hover{
                opacity:0.1;
            }
        </style>
        <script src="https://use.fontawesome.com/30e386e169.js"></script>
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script>
            let category;
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
            function passUsername(name)
            {
                username = name;
            }
            function passPassword(pass)
            {
                password = pass;
            }

            function checkLogin()
            {
                const data = {txtUsername: username, txtPassword: password};
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
            function makeSearch(searchNew)
            {
                let searchTmp = document.getElementById('txtSearchValue').value;
                let categoryTmp = document.getElementById('txtCategory').value;
                let minTmp = document.getElementById('txtMinPrice').value;
                let maxTmp = document.getElementById('txtMaxPrice').value;

                let search = searchTmp === undefined ? '' : searchTmp;
                let category = categoryTmp === undefined ? '' : categoryTmp;
                let min = minTmp === undefined ? '' : minTmp;
                let max = maxTmp === undefined ? '' : maxTmp;
                min = min.trim().replace(/\s\s+/g, ' ');
                max = max.trim().replace(/\s\s+/g, ' ');
                checkValid(search.trim().replace(/\s\s+/g, ' '), category, min, max, searchNew);
            }
            function hasUnicode(str) {
                for (var i = 0; i < str.length; i++) {
                    if (str.charCodeAt(i) > 127)
                        return true;
                }
                return false;
            }
            var index = 1;
            var size = 0;
            function checkValid(search, category, min, max, searchNew)
            {
                if (min === '')
                    min = '0';
                if (max === '')
                    max = '0';
                if (hasUnicode(search))
                {
                    swal("Notice!", "Search value isn't unicode character", "error");
                    return;
                }

                console.log(min);
                console.log(max);
                var reg = '[0-9]*[.]?[0-9]*';
                let tmp1 = min.match(reg)[0];
                let tmp2 = max.match(reg)[0];
                if ((min.length !== tmp1.length || tmp1 === '') || (max.length !== tmp2.length || tmp2 === ''))
                {
                    swal("Notice!", "Min or Max isn't float format", "error");
                    return;
                }
                let one = parseFloat(min);
                let two = parseFloat(max);
                if (one > two)
                {
                    swal("Notice!", "Min not > Max", "error");
                    return;
                }
                if (searchNew === 'yes')
                    index = 1;
                window.location.replace("http://localhost:8080/lab1/DispatcherServlet?btnAction=Search&txtSearchValue=" + search + "&txtCategory=" + category + "&txtMinPrice=" + one + "&txtMaxPrice=" + two + "&txtIndex=" + index);
            }

        </script>
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
            function passUsername(name)
            {
                username = name;
            }
            function passPassword(pass)
            {
                password = pass;
            }
            var isAddCart = false;
            function checkLogin(param)
            {
                if (param !== undefined)
                {
                    var form = document.getElementById("form_cart");
                    const data = new FormData(form);
                    const value = Object.fromEntries(data.entries());
                    if(isAddCart)
                        window.location.replace('https://accounts.google.com/o/oauth2/auth?client_id=946174400774-qb5n6hkf4fm3ni69io6p6s39vp39dsgh.apps.googleusercontent.com&scope=email&redirect_uri=http://localhost:8080/lab1/DispatcherServlet?btnAction=Login&state=' + JSON.stringify(value) + '&response_type=code');
                    else
                        window.location.replace('https://accounts.google.com/o/oauth2/auth?client_id=946174400774-qb5n6hkf4fm3ni69io6p6s39vp39dsgh.apps.googleusercontent.com&scope=email&redirect_uri=http://localhost:8080/lab1/DispatcherServlet?btnAction=Login'+'&response_type=code');
                    return;
                }
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
                                if (isAddCart)
                                {
                                    document.getElementById("form_cart").submit();
                                    return;
                                }
                                makeSearch();
                            }
                        });
            }

            function failLogin()
            {
                swal("Sorry!", "Not exits account in Hana Shop", "error");
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
            var numberOfMax = 1;
            function minus()
            {
                var inputText = document.getElementById("quantity");
                if (parseInt(inputText.value) >= 2)
                {
                    inputText.value = parseInt(inputText.value) - 1;
                    document.getElementById('amount').value = inputText.value;
                }
            }
            function plus()
            {
                var inputText = document.getElementById("quantity");
                if ((parseInt(inputText.value) + 1) > parseInt(numberOfMax))
                {
                    return;
                }
                inputText.value = parseInt(inputText.value) + 1;
                document.getElementById('amount').value = inputText.value;
            }
            function detail(data)
            {
                const img = document.getElementById("modal_img");
                const title = document.getElementById("modal_title");
                const type = document.getElementById("modal_type");
                const price = document.getElementById("modal_price");
                const content = document.getElementById("modal_content");
                const productId = document.getElementById("productId");
                const date = document.getElementById("modal_date");
                const quantity = document.getElementById("modal_quantity");

                numberOfMax = data.quantity;

                img.src = data.img;
                title.innerHTML = data.title;
                type.innerHTML = "Thể loại: " + data.type;
                price.innerHTML = "Giá: " + data.price + "$";
                content.innerHTML = data.content;
                date.innerHTML = "Ngày vào kho: " + data.date;
                quantity.innerHTML = "Số lượng: " + (data.quantity <= 0 ? 0 : data.quantity);
                const input = document.getElementById("quantity");
                if (data.quantity <= 0)
                    input.value = 0;
                else
                    input.value = 1;
                productId.value = data.id;
            }
            var index = 1;
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

        </script>
    </head>
    <body onLoad="clickTag(${param.txtIndex})">
        <c:if test="${not empty applicationScope.RECOMMENT}">
            <div id="nav-left">
                <c:forEach var="items" items="${applicationScope.RECOMMENT}" varStatus="counter">
                    <div style="height:18vh;width:100%;position:relative">
                        <i class="fa fa-bookmark" style="position:absolute;background-color:orange;width:100%;font-weight:bold">Sale Hot ${counter.count % 2 == 0 ? '25%' : '50%'}</i>
                        <div style="position:absolute;right:0;top:10%">
                            <i class="fa fa-times"></i>&nbsp;<span style="text-decoration: line-through;color:red">${String.format("%.2f",(counter.count % 2 != 0 ? items.price*2 : items.price*100/75))}$</span> <br/>
                            <i class="fa fa-thumbs-o-up"></i>&nbsp;<span style="color:blue">${String.format("%.2f",items.price)}$</span>
                        </div>
                        <c:if test="${items.quantity > 0}">
                            <a class="decor" style="height:inherit;width:100%" onClick="detail({id: '${items.productId}', img: '${items.image}', title: '${items.name}', type: '${items.passCategory()}', content: '${items.description}', price: '${items.price}', quantity: '${items.quantity}', date: '${items.passTime()}'})"data-toggle="modal" href='#modal-id'>
                                <img src="${items.image}" style="height:inherit;width:100%"/>
                            </a>
                        </c:if>
                        <c:if test="${items.quantity <= 0}">
                            <a style="height:inherit;width:100%" type="button" >
                                <img src="${items.image}" style="height:inherit;width:100%"/>
                                <label class="label label-warning" style="position:absolute;top:50%;left:25%;visibility: visible">Đã hết hàng</label> 
                            </a>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        <c:if test="${not empty requestScope.RECOMMENT2}">
            <div id="nav-right">
                <c:forEach var="items" items="${requestScope.RECOMMENT2}" varStatus="counter">
                    <div style="height:18vh;width:100%;position:relative">
                        <i class="fa fa-bookmark" style="position:absolute;background-color:orange;width:100%;font-weight:bold">Sale Hot ${counter.count % 2 == 0 ? '25%' : '50%'}</i>
                        <div style="position:absolute;right:0;top:10%">
                            <i class="fa fa-times"></i>&nbsp;<span style="text-decoration: line-through;color:red">${String.format("%.2f",(counter.count % 2 != 0 ? items.price*2 : items.price*100/75))}$</span> <br/>
                            <i class="fa fa-thumbs-o-up"></i>&nbsp;<span style="color:blue">${String.format("%.2f",items.price)}$</span>
                        </div>
                        <c:if test="${items.quantity > 0}">
                            <a class="decor" style="height:inherit;width:100%" onClick="detail({id: '${items.productId}', img: '${items.image}', title: '${items.name}', type: '${items.passCategory()}', content: '${items.description}', price: '${items.price}', quantity: '${items.quantity}', date: '${items.passTime()}'})"data-toggle="modal" href='#modal-id'>
                                <img src="${items.image}" style="height:inherit;width:100%"/>
                            </a>
                        </c:if>
                        <c:if test="${items.quantity <= 0}">
                            <a style="height:inherit;width:100%" type="button" >
                                <img src="${items.image}" style="height:inherit;width:100%"/>
                                <label class="label label-warning" style="position:absolute;top:50%;left:25%;visibility: visible">Đã hết hàng</label> 
                            </a>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        <div class="modal fade" id="modal-id2">
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

                                            <div style="margin-top:5%;" id="google">
                                                <button type="button" onClick="checkLogin()" class="btn btn-primary">Đăng
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
                        <input type="button" class="btn btn-danger"onClick="checkLogin('')"value="Đăng nhập bằng Google" />
                        <!-- <button type="button" class="btn btn-default" data-dismiss="modal">Close</button> -->
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="modal-id">
            <div class="modal-dialog" style="width:auto;">
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

                                        <form action="DispatcherServlet" method="POST" >

                                            <div class="form-group">
                                                <label for="">Username</label>
                                                <input type="text" class="form-control" onChange="passUsername(this.value)"  name="txtUsername"
                                                       placeholder="admin">
                                                <label for="">Password</label>
                                                <input type="password" onChange="passPassword(this.value)" class="form-control"  name="txtPassword"
                                                       placeholder="admin">
                                                <div style="margin-top:5%">

                                                    <button type="button" class="btn btn-danger">Google Account</button>

                                                </div>
                                            </div>
                                            <input type="reset" style="display:none;"/>
                                        </form>

                                    </div>
                                </div>

                            </div>
                            <div class="modal-footer" style="text-align:center">
                                <button type="button" class="btn btn-danger">Google Account</button>
                                <button type="button" onClick="checkLogin('yes')" class="btn btn-primary">Đăng
                                    nhập</button>
                                <!-- <button type="button" class="btn btn-default" data-dismiss="modal">Close</button> -->
                            </div>
                        </div>
                    </div>
                </div>
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



                                        <span class="label label-primary" id="modal_type" >Thể loại: Thức ăn</span> <br/>
                                        <span class="label label-info" id="modal_date">Giá: 8000 VNĐ</span> <br/>
                                        <span class="label label-success" id="modal_price">Giá: 8000 VNĐ</span> <br/>
                                        <span class="label label-warning" id="modal_quantity">Giá: 8000 VNĐ</span> <br/>
                                        <span class="label label-success" style="margin-bottom:0">Nội dung:</span>
                                        <p id="modal_content" style="overflow: hidden;max-height: 100px;max-width:300px;margin-top:5px">
                                        </p>
                                        <form action="DispatcherServlet"  style="position:absolute;bottom:0;left:30%" id="form_cart">
                                            <input type="hidden" name="txtProductId" id="productId" />
                                            <input type="hidden" name="txtSearchValue" value="${param.txtSearchValue}" />
                                            <input type="hidden" name="txtMinPrice" value="${param.txtMinPrice}" />
                                            <input type="hidden" name="txtMaxPrice" value="${param.txtMaxPrice}" />
                                            <input type="hidden" name="txtCategory" value="${param.txtCategory}" />
                                            <input type="hidden" name="txtIndex" value="1" />
                                            <input type="hidden" id="amount" name="txtQuantity" value="1" />
                                            <button onClick="minus()" type="button"><i class="fa fa-minus-circle"></i></button>
                                            <input type="text" id="quantity" disabled="true" value="1" style="width: 25px;text-align: center;"></input>
                                            <button onClick="plus()" type="button"><i class="fa fa-plus-circle"></i></button>
                                            &nbsp;
                                            <c:if test="${not empty sessionScope.ACCOUNT && sessionScope.ACCOUNT.role != 1}">
                                                <button type="submit" name="btnAction" value="AddToCart"class="btn btn-danger"><i class="fa fa-shopping-cart"></i> Vào Giỏ</button>
                                            </c:if>
                                            <c:if test="${empty sessionScope.ACCOUNT}">
                                                <input type="hidden" value="AddToCart" name="btnAction" />
                                                <button type="button" onClick="isAddCart = true;" data-toggle="modal" data-target="#modal-id2" name="btnAction" value="AddToCart"class="btn btn-danger"><i class="fa fa-shopping-cart"></i> Vào Giỏ</button>
                                            </c:if>
                                            <c:if test="${not empty sessionScope.ACCOUNT && sessionScope.ACCOUNT.role == 1}">
                                                <button type="button" onClick="swal('Sorry!', 'Admin hasn\'t allowed', 'warning');" class="btn btn-danger"><i class="fa fa-shopping-cart"></i> Vào Giỏ</button>
                                            </c:if>

                                        </form>
                                    </div>
                                </div>

                            </div>

                        </div>

                    </div>
                </div>
            </div>
        </div>


        <div class="container">

            <div class="row" style="background-color: black;border-radius:0 10px 10px 0">

                <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4" style="position:relative;left:-18px;padding-left:0;padding-right:0;height:40px;">
                    <form action="google.com" method="POST">
                        <div class="input-group">
                            <input id="txtSearchValue" value="${param.txtSearchValue}" type="text" class="form-control" style="height: 40px;border-radius:30px 0 0 30px;" id="exampleInputAmount" placeholder="eg. Food"/>
                            <span class="input-group-btn">
                                <button onClick="makeSearch('yes')" type="button"style="height: 40px;" class="btn btn-primary"><span class="fa fa-search"></span>
                                    Tìm</button>
                            </span>
                        </div>
                    </form>
                </div>

                <div class="col-xs-8 col-sm-8 col-md-8 col-lg-8" style="padding-left:0;padding-right:0">


                    <c:if test="${sessionScope.ACCOUNT.role != 1}">
                        <ul class="nav navbar-nav" style="float:right;">
                            <li>
                                <a href="/lab1"><i class="fa fa-home" aria-hidden="true"></i> Trang chủ</a>
                            </li>
                            <li style="background-color:rgb(255,255,255);">
                                <a type="button"><i class="fa fa-shopping-cart" aria-hidden="true"></i> Mua sắm</a>
                            </li>
                            <li>
                                <c:if test="${not empty sessionScope.ACCOUNT}">
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
                                </c:if>
                                <c:if test="${empty sessionScope.ACCOUNT}">
                                    <a data-toggle="modal" data-target="#modal-id2" ><i class="fa fa-sign-in" aria-hidden="true"></i> Đăng nhập</a>
                                </c:if>
                            </li>
                        </ul>
                    </c:if>
                    <c:if test="${sessionScope.ACCOUNT.role == 1}">
                        <ul class="nav navbar-nav" style="float:right;">
                            <li>
                                <a href="DispatcherServlet?btnAction=Admin"><i class="fa fa-home" aria-hidden="true"></i> Trang Quản Lí</a>
                            <li style="background-color:rgb(255,255,255);">
                                <a type="button"><i class="fa fa-shopping-cart" aria-hidden="true"></i> Mua sắm</a>
                            </li>
                            <li>
                                <c:if test="${not empty sessionScope.ACCOUNT}">
                                    <div class="dropdown">
                                        <button class="btn btn-primary dropdown-toggle" style="padding:10px;height: 40px;border-radius: 0 4px 4px 0;" type="button" data-toggle="dropdown">
                                            <i class="fa fa-user" aria-hidden="true"></i> ${sessionScope.ACCOUNT.lastname}</button>
                                        <ul class="dropdown-menu" style="min-width: 120px">
                                            <li><a onClick="swal('Waiting', 'In update processing.....', 'warning');" type="button">Thông tin</a></li>
                                            <li><a href="">Lịch sử</a></li>
                                            <li><a href="DispatcherServlet?btnAction=Logout">Log out</a></li>
                                        </ul>
                                    </div>
                                </c:if>
                                <c:if test="${empty sessionScope.ACCOUNT}">
                                    <a data-toggle="modal" data-target="#modal-id2" ><i class="fa fa-sign-in" aria-hidden="true"></i> Đăng nhập</a>
                                </c:if>
                            </li>
                        </ul>
                    </c:if>

                </div>
            </div>
            <div class="row" style="height:88vh;padding:0 3px 0 3px;">



                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12"  style="padding-bottom:18px">


                    <form action="" method="POST" class="form-inline" style="text-align:center;padding-top:30px">

                        <div class="form-group">

                            <span class="label label-warning">Thể loại</span> <br />
                            <select id="txtCategory" name="txtCategory" id="input" class="form-control" style="margin-bottom:10px;">
                                <option value="All" >-- Tất Cả --</option>
                                <option value="Food" ${param.txtCategory.equals('Food') ? 'selected':''}>Food</option>
                                <option value="Drink" ${param.txtCategory.equals('Drink') ? 'selected':''}>Drink</option>
                                <option value="Vegetable"${param.txtCategory.equals('Vegetable') ? 'selected':''} >Vegetable</option>
                            </select>
                            <br />


                            <span class="label label-warning">Min Price</span>
                            <input id="txtMinPrice" type="text" value="${param.txtMinPrice}" class="form-control" id="" placeholder="Min"></input> &nbsp;
                            <input id="txtMaxPrice" type="text" value="${param.txtMaxPrice}" class="form-control" id="" placeholder="Max"></input>
                            <span class="label label-warning">Max Price</span>

                        </div>

                    </form>

                </div>

                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="items"style="max-width:1184px;max-height:440px;height: 440px;padding-left: 0;padding-right: 0">
                    <c:if test="${not empty requestScope.LIST}">
                        <c:forEach var="item" items="${requestScope.LIST}">
                            <c:if test="${item.quantity > 0}">
                                <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4" id="thumbnail" >

                                    <a class="thumbnail" type="button">
                                        <img src="${item.image}" alt="">
                                        <button class="btn btn-primary" onClick="detail({id: '${item.productId}', img: '${item.image}', title: '${item.name}', type: '${item.passCategory()}', content: '${item.description}', price: '${item.price}', quantity: '${item.quantity}', date: '${item.passTime()}'})"data-toggle="modal" href='#modal-id'>Xem chi tiết</button>
                                    </a>

                                </div>
                            </c:if>
                            <c:if test="${item.quantity <= 0}">
                                <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4" id="thumbnail">
                                    <a class="thumbnail" style="transition:none;transform:none"type="button">
                                        <img src="${item.image}" alt="">
                                        <label class="label label-warning" style="font-size:17px;position:absolute;top:45%;left:35%;visibility: visible">Đã hết hàng</label> 
                                    </a>
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty requestScope.LIST}">
                        <h1 style="max-height: inherit;height: inherit"></h1>
                        <%
                            request.setAttribute("SIZE", 0);
                        %>
                    </c:if>
                </div>

                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" style="text-align:center">

                    <ul class="pagination">
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

            </div>
        </div>
        <!-- jQuery -->
        <script src="framework/js/jquery-3.2.1.min.js"></script>
        <!-- Bootstrap JavaScript -->
        <script src="framework/js/bootstrap.min.js"></script>
        <script>
                            $('#modal-id2').on('show.bs.modal', function () {
                                // Load up a new modal...
                                $('#modal-id').modal('hide');
                            })
                            $('#modal-id2').on('hide.bs.modal', function () {
                                isAddCart = false;
                            })
        </script>
    </body>
</html>

