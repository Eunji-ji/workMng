package com.sp.workMng;

import java.util.List;

public interface WorkMngService {
	
	// 할 일 조회
	public List<WorkMng> selectTodoList(String userId);
	// 할 일 등록 
	public void insertTodoList(WorkMng dto) throws Exception;
	// 할 일 삭제 
	public void deleteTodoList(int todoNum) throws Exception;

	// plan 조회
	public List<WorkMng> selectPlanList(String userId);
	// plan 등록 
	public void insertPlan(WorkMng dto) throws Exception;
	// plan 삭제 
	public void deletePlan(int todoNum) throws Exception;

	// memo 조회
	public List<WorkMng> selectMemoList(String userId);
	// memo 등록 
	public void insertMemo(WorkMng dto) throws Exception;
	// memo 삭제 
	public void deleteMemo(int todoNum) throws Exception;

}
