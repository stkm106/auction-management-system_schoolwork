<%-- 
    Document   : detail
    Created on : Jun 24, 2026, 8:47:57 PM
    Author     : San
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<h3 class="mt-3">${product.productName}</h3>

<div class="card">

    <div class="row g-0">

        <div class="col-md-4">

            <img src="${pageContext.request.contextPath}/resources/images/products/${product.imageURL}"
                 class="img-fluid rounded-start">

        </div>

        <div class="col-md-8">

            <div class="card-body">

                <p><strong>Mã:</strong> ${product.productID}</p>

                <p><strong>Description:</strong> ${product.description}</p>

                <p><strong>Starting Price:</strong> ${product.startingPrice}</p>

                <p><strong>Status:</strong> ${product.status}</p>

                <a href="${pageContext.request.contextPath}/products/browse"
                   class="btn btn-secondary">
                    Back
                </a>

            </div>

        </div>

    </div>

</div>

