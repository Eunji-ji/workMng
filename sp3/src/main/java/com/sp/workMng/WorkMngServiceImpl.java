package com.sp.workMng;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sp.common.dao.CommonDAO;

@Service("workMng.workMngService")
public class WorkMngServiceImpl implements WorkMngService{

	@Autowired
	private CommonDAO dao;

	/**
	 * 할일 리스트 출력
	 * @param : userId
	 * @return : List
	 **/
	@Override
	public List<WorkMng> selectTodoList(String userId) {
		List<WorkMng> todolist = null;
		try {
			todolist = dao.selectList("dashboard.selectTodoList", userId);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
		}
		System.out.println(todolist);
		return todolist;
	}

	/**
	 * 할일 등록
	 * @param : dto
	 * @return : 
	 **/	
	@Override
	public void insertTodoList(WorkMng dto) throws Exception {
		try{
			dao.insertData("dashboard.insertTodoList", dto);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	/**
	 * 할일 삭제
	 * @param : todoNum
	 * @return : 
	 **/	
	@Override
	public void deleteTodoList(int todoNum) throws Exception {
		try{
			dao.deleteData("dashboard.deleteTodoList", todoNum);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	/**
	 * PLAN 리스트 출력
	 * @param : userId
	 * @return : List
	 **/
	@Override
	public List<WorkMng> selectPlanList(String userId) {
		List<WorkMng> planlist = null;
		try {
			planlist = dao.selectList("dashboard.selectPlanList", userId);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
		}
		System.out.println(planlist);
		return planlist;
	}
	
	/**
	 * PLAN 저장
	 * @param : userId
	 * @return : List
	 **/
	@Override
	public void insertPlan(WorkMng dto) throws Exception {
		try{
			dao.insertData("dashboard.insertPlan", dto);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	/**
	 * PLAN 삭제
	 * @param : planNum
	 * @return : 
	 **/
	@Override
	public void deletePlan(int planNum) throws Exception {
		try{
			dao.deleteData("dashboard.deletePlan", planNum);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	/**
	 * MEMO 리스트 출력
	 * @param : userId
	 * @return : List
	 **/
	@Override
	public List<WorkMng> selectMemoList(String userId) {
		List<WorkMng> memolist = null;
		try {
			memolist = dao.selectList("dashboard.selectMemoList", userId);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
		}
		System.out.println(memolist);
		return memolist;
	}

	/**
	 * memo 등록
	 * @param : dto
	 * @return : 
	 **/	
	@Override
	public void insertMemo(WorkMng dto) throws Exception {
		try{
			dao.insertData("dashboard.insertMemo", dto);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		}		
	}

	/**
	 * memo 삭제
	 * @param : memoNum
	 * @return : 
	 **/	
	@Override
	public void deleteMemo(int memoNum) throws Exception {
		try{
			dao.deleteData("dashboard.deleteMemo", memoNum);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		}		
	}

	/**
	 * memo 내용조회
	 * @param : memoNum
	 * @return : dto
	 **/	
	@Override
	public WorkMng selectMemoContent(int memoNum) {
		WorkMng memo = null;
		try {
			memo = dao.selectOne("dashboard.selectMemoContent", memoNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return memo;
	}
}
