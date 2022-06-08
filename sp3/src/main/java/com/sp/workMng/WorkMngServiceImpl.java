package com.sp.workMng;

import java.util.List;

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

	@Override
	public void insertTodoList(WorkMng dto) throws Exception {
		try{
			dao.insertData("guest.insertGuest", dto);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void deleteTodoList(int todoNum) throws Exception {
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

	@Override
	public void insertPlan(WorkMng dto) throws Exception {
	}

	@Override
	public void deletePlan(int todoNum) throws Exception {
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

	@Override
	public void insertMemo(WorkMng dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteMemo(int todoNum) throws Exception {
		// TODO Auto-generated method stub
		
	}

}
