<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<section class="section-padding">
	<div class="container mt-4 nanum">
		<h2 class="mb-4">${accessTitle}</h2>
		<div class="container">
			<div class="row justify-content-left main-content-container">
				<div class="col-md-8 col-lg-6">
					<div class="mt-4">
						<div class="align-left">
							<p id="result_p" class="mt-0">${accessMsg}</p>
							<input type="button" value="${accessBtn}" class="custom-btn btn text-small"
								onclick="location.href='${accessUrl}'">
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>