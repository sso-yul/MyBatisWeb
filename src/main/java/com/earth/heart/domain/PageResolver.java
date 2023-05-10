package com.earth.heart.domain;
//특정 페이지에서 앞, 뒤로 이동할 때 그 경로를 해결해주는 클래스
//페이지 내비게이션

public class PageResolver {
	
	private SearchItem sc;
	
	private int totalCnt;				//게시물의 총 개수
	private int pageSize;				//한 페이지 당 지정된 게시물 개수
	private final int NAV_SIZE = 10;	//페이지 내비게이션 사이즈
	
	private int totalPage;				//전체 페이지 개수
	private int page;					//현재 페이지
	
	private int beginPage;				//내비게이션의 첫 페이지 숫자
	private int endPage;				//내비게이션의 끝 페이지 숫자(10단위라면 10, 20, 30, ...)
	private boolean showNext = false;	//다음 페이지로 이동하는 링크를 보여줄지 안 보여줄지 여부(화살표 다음) endPage==totalPage이면 showNext는 false
	private boolean showPrev = false;	//이전 페이지로 이동하는 링크를 보여줄지 안 보여줄지 여부(화살표 이전) beginPage==1이 아니면 ShowPrev는 true

	public PageResolver(int totalCnt, Integer page) {
		this(totalCnt, new SearchItem(page, 10));
	}
	
	public PageResolver(int totalCnt, Integer page, Integer pageSize) {
		this(totalCnt, new SearchItem(page, pageSize));
	}
	
	public PageResolver(int totalCnt, SearchItem sc) {	//웹 페이지 어디를 클릭했을 때 어디서부터 어디까지 나오고 그런 기능을 구현하는 것 , 페이지 네비게이션 객체 설정할 때 같이 만들어져서 나와줘야 함
		this.totalCnt = totalCnt;
		this.sc = sc;
		
		doPaging(totalCnt, sc);		//이거에 의해서 두페이징이 계산 되게끔
		
	}

	private void doPaging(int totalCnt, SearchItem sc) {
		//두페이징을 일반화시키기
		this.totalPage = totalCnt / sc.getPageSize() + (totalCnt % sc.getPageSize() == 0 ? 0 : 1);	
		this.sc.setPage(Math.min(sc.getPage(), totalPage));		//page가 totalPage보다 크지 않음 .괄호 안 페이지 중 작은 값이 선택됨. 당연한 거지만 명시해줄 필요 있음
		
		
		//현재 페이지(page)를 네비게이션 크기로 나누고 다시 그 크기만큼 곱해 일의 자리 수를 0으로 만든 뒤 1을 더함
		this.beginPage = (this.sc.getPage()-1) / NAV_SIZE * NAV_SIZE + 1;				// 25/10*10+1 -> 21, 29/10*10+1 -> 21 따라서 이렇게 일반화하면 비긴페이지는 항상 일의 자리가 1로 끝나게 됨
		//네비개이션의 마지막 페이지 숫자
		//beginPage에 네비개이션 크기를 더하고 1을 뺀 값과 총 페이지수(totalPage) 중에 적은 것을 구함
		this.endPage = Math.min(this.beginPage + this.NAV_SIZE - 1, totalPage);			//이렇게 하면 20 페이지까지 안 나오고 게시글의 마지막 개수가 있는 11 12 13 14(막페이지) 이렇게만 나옴
		
		//beginPage가 1이 아니면 true(< 기호 보일지말지 여부)
		this.showPrev = beginPage != 1;
		//endPage가 totalPage가 아니면 true ( > 기호 여부)
		this.showNext = endPage != totalPage;
	}
	
	public void print() {
		System.out.println("현재 페이지 (page) = " + sc.getPage());
		System.out.print(showPrev ? "PREV " : "(빈문자열)");
		
		for(int i = beginPage; i <= endPage; i++) {		// 네비바 숫자들 띄워주기 1 2 3 4 5 6 7 8 9 10 >
			System.out.print(i + " ");
		}
		
		System.out.println(showNext ? " NEXT" : "(빈문자열)");
	}

	@Override
	public String toString() {
		return "PageResolver [sc=" + sc + ", totalCnt=" + totalCnt + ", pageSize=" + pageSize + ", NAV_SIZE=" + NAV_SIZE
				+ ", totalPage=" + totalPage + ", page=" + page + ", beginPage=" + beginPage + ", endPage=" + endPage
				+ ", showNext=" + showNext + ", showPrev=" + showPrev + "]";
	}

	public SearchItem getSc() {
		return sc;
	}

	public void setSc(SearchItem sc) {
		this.sc = sc;
	}

	public int getTotalCnt() {
		return totalCnt;
	}

	public void setTotalCnt(int totalCnt) {
		this.totalCnt = totalCnt;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getBeginPage() {
		return beginPage;
	}

	public void setBeginPage(int beginPage) {
		this.beginPage = beginPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public boolean isShowNext() {
		return showNext;
	}

	public void setShowNext(boolean showNext) {
		this.showNext = showNext;
	}

	public boolean isShowPrev() {
		return showPrev;
	}

	public void setShowPrev(boolean showPrev) {
		this.showPrev = showPrev;
	}

	public int getNAV_SIZE() {
		return NAV_SIZE;
	}
	
	
}
