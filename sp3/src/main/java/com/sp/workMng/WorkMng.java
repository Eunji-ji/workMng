package com.sp.workMng;

public class WorkMng {

	/* 할일 DTO */
	private int toDoNum;
	private String todoSubject;
	private String todoContent;
    private String todoCreatDt;
    private String importance; 
    
    /* PLAN DTO */
	private int planNum;
    private String planTm;
	private String planSubject;
    private String planCreatDt;
	
	/* MEMO DTO */
	private String memoNum;
	private String memoSubject;
	private String memoContent;
    private String memoCreatDt;

	/* 공통 */
    private String userId;
    
    public int getToDoNum() {
		return toDoNum;
	}
	public void setToDoNum(int toDoNum) {
		this.toDoNum = toDoNum;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getPlanNum() {
		return planNum;
	}
	public void setPlanNum(int planNum) {
		this.planNum = planNum;
	}
	public String getPlanTm() {
		return planTm;
	}
	public void setPlanTm(String planTm) {
		this.planTm = planTm;
	}
	public String getMemoNum() {
		return memoNum;
	}
	public void setMemoNum(String memoNum) {
		this.memoNum = memoNum;
	}
	public String getTodoSubject() {
		return todoSubject;
	}
	public void setTodoSubject(String todoSubject) {
		this.todoSubject = todoSubject;
	}
	public String getTodoContent() {
		return todoContent;
	}
	public void setTodoContent(String todoContent) {
		this.todoContent = todoContent;
	}
	public String getTodoCreatDt() {
		return todoCreatDt;
	}
	public void setTodoCreatDt(String todoCreatDt) {
		this.todoCreatDt = todoCreatDt;
	}
	public String getPlanSubject() {
		return planSubject;
	}
	public void setPlanSubject(String planSubject) {
		this.planSubject = planSubject;
	}
	public String getPlanCreatDt() {
		return planCreatDt;
	}
	public void setPlanCreatDt(String planCreatDt) {
		this.planCreatDt = planCreatDt;
	}
	public String getMemoSubject() {
		return memoSubject;
	}
	public void setMemoSubject(String memoSubject) {
		this.memoSubject = memoSubject;
	}
	public String getMemoContent() {
		return memoContent;
	}
	public void setMemoContent(String memoContent) {
		this.memoContent = memoContent;
	}
	public String getMemoCreatDt() {
		return memoCreatDt;
	}
	public void setMemoCreatDt(String memoCreatDt) {
		this.memoCreatDt = memoCreatDt;
	}
	public String getImportance() {
		return importance;
	}
	public void setImportance(String importance) {
		this.importance = importance;
	}
	
} 
    