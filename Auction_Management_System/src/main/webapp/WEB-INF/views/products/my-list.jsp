<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>



<div class="page-header">

    <div>

        <h1>Sản phẩm của tôi</h1>

        <div class="breadcrumb-custom">Tài khoản &gt; Sản phẩm của tôi</div>

    </div>

    <div class="d-flex gap-2">

        <a href="${ctx}/products/my/create" class="btn btn-gold btn-sm btn-header-action">

            <i class="bi bi-plus-lg"></i> Thêm sản phẩm

        </a>

    </div>

</div>



<div class="data-table-wrap">

    <table class="table data-table mb-0">

        <thead>

        <tr>

            <th>Mã</th>

            <th>Tên sản phẩm</th>

            <th>Giá khởi điểm</th>

            <th>Trạng thái</th>

            <th>Thao tác</th>

        </tr>

        </thead>

        <tbody>

        <c:forEach var="p" items="${products}">

            <c:set var="auction" value="${auctionMap[p.productID]}"/>

            <tr>

                <td>${p.productCode}</td>

                <td>

                    <a href="${ctx}/products/my/detail/${p.productID}" class="text-decoration-none fw-bold product-name-link">

                        ${p.productName}

                    </a>

                </td>

                <td><fmt:formatNumber value="${p.startingPrice}" groupingUsed="true"/> &#8363;</td>

                <td>

                    <c:choose>

                        <c:when test="${p.status == 'Pending'}">

                            <span class="badge-status badge-pending">Chờ duyệt</span>

                        </c:when>

                        <c:when test="${p.status == 'Rejected'}">

                            <span class="badge-status badge-locked">Từ chối</span>

                        </c:when>

                        <c:when test="${p.status == 'Approved' && auction == null}">

                            <span class="badge-status badge-active">Đã duyệt &mdash; Chờ tạo phiên đấu giá</span>

                        </c:when>

                        <c:when test="${p.status == 'Approved' && auction != null}">

                            <c:choose>

                                <c:when test="${auction.effectiveStatus == 'Upcoming'}">

                                    <span class="badge-status badge-pending">Đã duyệt &mdash; Phiên sắp diễn ra</span>

                                </c:when>

                                <c:when test="${auction.effectiveStatus == 'Open'}">

                                    <span class="badge-status badge-active">Đang đấu giá</span>

                                </c:when>

                                <c:when test="${auction.effectiveStatus == 'Closed'}">

                                    <span class="badge-status badge-ended">Phiên đã kết thúc</span>

                                </c:when>

                                <c:otherwise>

                                    <span class="badge-status">${auction.status}</span>

                                </c:otherwise>

                            </c:choose>

                        </c:when>

                        <c:when test="${p.status == 'Auctioning'}">

                            <span class="badge-status badge-active">Đang đấu giá</span>

                        </c:when>

                        <c:when test="${p.status == 'Sold'}">

                            <span class="badge-status badge-active">Đã bán</span>

                        </c:when>

                        <c:otherwise>

                            <span class="badge-status">${p.status}</span>

                        </c:otherwise>

                    </c:choose>

                </td>

                <td>

                    <a href="${ctx}/products/my/detail/${p.productID}" class="btn btn-outline-secondary btn-sm">

                        Xem chi tiết

                    </a>

                </td>

            </tr>

        </c:forEach>

        <c:if test="${empty products}">

            <tr>

                <td colspan="5" class="text-center text-muted py-4">Bạn chưa có sản phẩm nào. Nhấn &quot;Thêm sản phẩm&quot; để đăng bán.</td>

            </tr>

        </c:if>

        </tbody>

    </table>

</div>


