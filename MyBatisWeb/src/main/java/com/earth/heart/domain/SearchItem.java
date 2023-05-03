package com.earth.heart.domain;
//검색 기능
import static java.util.Objects.requireNonNullElse;

import org.springframework.web.util.UriComponentsBuilder;

import static java.lang.Math.*;

public class SearchItem {

	public static final int DEFAULT_PAGE_SIZE = 10;	//상수로 정의함 기본 게시물 개수 10
	public static final int MIN_PAGE_SIZE = 5;		//최소 게시물 개수 5
	public static final int MAX_PAGE_SIZE = 50;		//최대 개시물 개수 50
	
	private Integer page = 1;
	private Integer pageSize = DEFAULT_PAGE_SIZE;
	private String keyword = "";
	private String option = "";
	
	public SearchItem() {}
	
	public SearchItem(Integer page, Integer pageSize) {
		this(page, pageSize, "", "");		//page, pageSize는 늘 있어야 하고 옵션과 키워드는 늘 없는 것이 디폴트(타자 치거나 드롭다운 선택해야 하니까)
	}
	
	public SearchItem(Integer page, Integer pageSize, String option, String keyword) {
		this.page = page;
		this.pageSize = pageSize;
		this.option = option;
		this.keyword = keyword;
	}
	//setter, getter 추가 예정

	public Integer getPageSize() {
		return pageSize;
	}

	public void setPageSize(Integer pageSize) {
		//pageSize가 null일 때 디폴트 값 반환하겠다
		this.pageSize = requireNonNullElse(pageSize, DEFAULT_PAGE_SIZE);	//페이지 사이즈가 null이 아니었을 때 디폴트 페이지 사이즈로 초기화하겠다
																			//기본은 이거 적용
		//MIN_PAGE_SIZE <= pageSize < MAX_PAGE_SIZE
		this.pageSize = max(MIN_PAGE_SIZE, min(this.pageSize, MAX_PAGE_SIZE));		//뭐라는거야..		
	}
	
	public Integer getPage() {
		return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}
	
	public String getQueryString() {
		return getQueryString(page);		//특정 페이지를 넘김
	}
	
	//?page=10&pageSize=10&option=A&keyword=title
	public String getQueryString(Integer page) {
		return UriComponentsBuilder.newInstance()		//이거 쓰면 쉽게 쿼리스트링 정보 생성해서 넘길 수 있음
				.queryParam("page", page)
				.queryParam("pageSize", pageSize)
				.queryParam("option", option)
				.queryParam("keyword", keyword)
				.build().toString();
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getOption() {
		return option;
	}

	public void setOption(String option) {
		this.option = option;
	}
	
	public Integer getOffset() {
		int result = (page - 1) * pageSize;
		if(result < 0) {
			result = 0;
		}
		return result;
	}
	
	
}
