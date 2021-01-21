<%-- 
    Document   : cart
    Created on : Jan 9, 2021, 11:14:10 PM
    Author     : Vinh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Giỏ Hàng</title>
        <link href="framework/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="framework/css/font-awesome.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <style>
            body {
                background: url(./images/shopping.jpg) no-repeat 0 0 fixed ;
                background-size: cover;
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

        </style>
        <script src="https://use.fontawesome.com/30e386e169.js"></script>
        <script src="https://www.paypalobjects.com/api/checkout.js"></script>
        <script>
            function plus()
            {
                const input = document.getElementById("quantity");
                input.value = parseInt(input.value) + 1;
            }
            function minus()
            {
                const input = document.getElementById("quantity");
                if (parseInt(input.value) >= 2)
                    input.value = parseInt(input.value) - 1;
            }
            function detail(data)
            {
                console.log(data);
                const img = document.getElementById("modal_img");
                const title = document.getElementById("modal_title");
                const type = document.getElementById("modal_type");
                const price = document.getElementById("modal_price");
                const content = document.getElementById("modal_content");
                const productId = document.getElementById("productId");
                img.src = data.img;
                title.innerHTML = data.title;
                type.innerHTML = data.type;
                price.innerHTML = data.price;
                content.innerHTML = data.content;
                const input = document.getElementById("quantity");
                input.value = 1;
                productId.value = data.id;
            }
            function hasUnicode(str) {
                for (var i = 0; i < str.length; i++) {
                    if (str.charCodeAt(i) > 127)
                        return true;
                }
                return false;
            }
            function update(productId, amount, index)
            {
                $.confirm({
                    title: 'Cập nhật số lượng sản phẩm',
                    content: '' +
                            '<form action="DispatcherServlet?btnAction=UpdateCart" method="POST" id="form_update">' +
                            '<div class="form-group">' +
                            '<label>Số lượng: </label>' +
                            '<input type="hidden" name="txtProductId" value="' + productId + '"/>' +
                            '<input type="hidden" name="txtAmount" value="' + amount + '"/>' +
                            '<input type="text" name="txtNumber" id="numberOfProduct" value="' + amount + '" placeholder="1" class="name form-control" />' +
                            '</div>' +
                            '</form>',
                    buttons: {
                        formSubmit: {
                            text: 'Cập nhật',
                            btnClass: 'btn-blue',
                            action: function () {
                                var number = document.getElementById("numberOfProduct");
                                let value = number.value;
                                console.log(value);
                                if (hasUnicode(value))
                                {
                                    $.alert('Hông chứa mã tiếng việt!');
                                    return;
                                }
                                var reg = /^\d+$/;
                                if (!value.match(reg))
                                {
                                    $.alert('Phải là chữ số 0-9!');
                                    return;
                                }
                                let tmp = parseInt(value);
                                if (tmp < 1)
                                {
                                    $.alert('Ít nhất là 1');
                                    return;
                                }
                                var params = {txtProducId: productId};
                                var quantity
                                $.ajax('http://localhost:8080/lab1/DispatcherServlet?btnAction=GetProduct',
                                        {
                                            type: "GET",
                                            cache: false,
                                            contentType: 'application/json',
                                            dataType: 'json',
                                            data: params,
                                            success: function (data)
                                            {
                                                let quantity = data.quantity;
                                                if (tmp > quantity)
                                                {
                                                    $.alert('Hiện tại trong kho chỉ còn ' + quantity);
                                                    return;
                                                }
                                                document.getElementById("form_update").submit();
                                            },
                                            error: function (error)
                                            {
                                                $.alert('Mời bạn cập nhật lại');
                                            }
                                        });

                            }
                        },
                        cancel: function () {
                            //close
                        },
                    }
                });
            }
            function remove(index)
            {
                $.confirm({
                    title: 'Xóa sản phẩm này?',
                    content: 'Tự động close dialog in 5s',
                    autoClose: 'Hủy|5000',
                    buttons: {
                        Delete: {
                            text: 'Xóa',
                            action: function () {
                                console.log("Yes");
                                document.getElementById("form_delete" + index).submit();
                            }
                        },
                        Hủy: function () {
//                            $.alert('action is canceled');
                        }
                    }
                });
//                $.confirm({
//                    title: 'Logout?',
//                    content: 'Your time is out, you will be automatically logged out in 10 seconds.',
//                    autoClose: 'logoutUser|10000',
//                    buttons: {
//                        logoutUser: {
//                            text: 'logout myself',
//                            action: function () {
//                                $.alert('The user was logged out');
//                            }
//                        },
//                        cancel: function () {
//                            $.alert('canceled');
//                        }
//                    }
//                });
            }
        </script>
    </head>

    <body>
        <c:if test="${not empty sessionScope.ACCOUNT && sessionScope.ACCOUNT.role != 1}">



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


                        <h1 style="text-align:center;font-weight: 1000;color:rgb(235, 72, 0);font-size: 51px;;text-shadow: 0 50px 10px red;"><i class="fa fa-shopping-cart" aria-hidden="true"></i> Shopping Cart</h1>


                    </div>

                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" id="items"style="max-width:1184px;max-height:440px;height: 440px;padding-left: 50px;padding-right: 50px;overflow-y:auto">



                        <div class="table-responsive" id="table">
                            <table class="table table-hover" style="color:black">
                                <thead style="background-color:rgba(255,255,255,0.5)">
                                    <tr>
                                        <th>No.</th>
                                        <th>Image</th>
                                        <th>Name</th>
                                        <th>Price</th>
                                        <th>Amount</th>
                                        <th>Total</th>
                                        <th>Yes/No</th>
                                        <th>Update</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:set var="cart" value="${requestScope.items}"></c:set>
                                    <c:if test="${not empty cart}">
                                        <c:forEach var="item" items="${cart}" varStatus="counter">
                                            <tr>
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
                                                <c:choose>
                                                    <c:when test="${not empty requestScope.ERRORLIST && requestScope.ERRORLIST.contains(item.key.productId)}">
                                                        <td style="border-top:0px;color:red">${item.value} (out of stock)</td>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <td style="border-top:0px">${item.value}</td>
                                                    </c:otherwise>
                                                </c:choose>

                                                <td style="border-top:0px">${String.format("%.2f",item.key.price*item.value)}$</td>
                                                <td style="position:relative;border-top:0px;padding-right:20px">
                                                    <form action="DispatcherServlet?btnAction=Remove" id="form_delete${counter.count}" method="POST">
                                                        <input type="hidden" name="txtProductId" value="${item.key.productId}" />
                                                        <input type="hidden" name="txtQuantity" value="${item.value}" />
                                                        <button type="button" onClick="remove(${counter.count});" style="position:absolute;top:20%;left:-20px;width:100%" class="btn btn-danger"><i
                                                                class="fa fa-times-circle"></i></button>

                                                    </form>
                                                </td>
                                                <td style="position:relative;border-top:0px;padding-right:20px">
                                                    <form action="DispatcherServlet?btnAction=Remove" id="form_update${counter.count}" method="POST">
                                                        <input type="hidden" name="txtProductId" value="${item.key.productId}" />
                                                        <input type="hidden" name="txtQuantity" value="${item.value}" />
                                                        <button type="button" onClick="update(${item.key.productId},${item.value},${counter.count});" style="position:absolute;top:20%;left:-10px;width:100%" class="btn btn-primary"><i
                                                                class="fa fa-pencil-square-o"></i></button>

                                                    </form>
                                                </td>
                                            </tr>
                                            <c:set var="total" value="${total+item.key.price*item.value}"></c:set>
                                        </c:forEach>
                                    </c:if>

                                </tbody>
                            </table>
                        </div>
                    </div>


                    <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12" style="position:relative;bottom:15px;text-align:center;height:82px;max-height:82px;">
                        <hr/>
                        <h1 style="text-align:center;color:rgb(235, 72, 0);text-shadow: 0 -40px 10px red;">
                            <span class="label label-danger" style="font-size: 25px;">
                                <c:set var="TOTAL" value="${total}" scope="session"></c:set>
                                Total : ${not empty total ? String.format("%.2f",total) : 0}$
                            </span>
                            <button type="button" onClick="window.location.replace('DispatcherServlet?btnAction=Checkout')" style="font-size:20px;height:40px;width:193px;margin-top:2px;padding-top:5px;text-align: center;width:inherit;" class="btn btn-success">Cash <i class="fa fa-money"></i></button>

                            <div id="paypal-button" style=""></div>

                            <script>
                                paypal.Button.render({
                                    env: 'sandbox',
                                    client: {
                                        sandbox: 'ATJNTjJErAxh5Vcme_WM9no11_qHUjdKn9r9UfnV6Xv2RbYXFwKZvFO4XtFEauZn3o9QzGfERUyw28uo'
                                    }, // Or 'production'
                                    // Set up the payment:
                                    // 1. Add a payment callback
                                    payment: function (data, actions) {
                                        // 2. Make a request to your server
                                        return actions.request.post('http://localhost:8080/lab1/DispatcherServlet?btnAction=Payment')
                                                .then(function (res) {
                                                    // 3. Return res.id from the response
                                                    return res.id;
                                                });
                                    },
                                    // Execute the payment:
                                    // 1. Add an onAuthorize callback
                                    onAuthorize: function (data, actions) {
                                        // 2. Make a request to your server
                                        return actions.request.post('http://localhost:8080/lab1/DispatcherServlet?btnAction=Payment&isSubmit=', {
                                            paymentID: data.paymentID,
                                            payerID: data.payerID
                                        })
                                                .then(function (res) {
                                                    window.location.replace('DispatcherServlet?btnAction=Checkout');
                                                });
                                    }
                                }, '#paypal-button');
                            </script>
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
        <!-- Bootstrap JavaScript -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>

    </body>
</html>

