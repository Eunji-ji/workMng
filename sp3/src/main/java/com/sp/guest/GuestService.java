package com.sp.guest;

import java.util.List;
import java.util.Map;

public interface GuestService {
	public void insertGuest(Guest dto) throws Exception;
	public List<Guest> listGuest(Map<String, Object> map);
	public int dataCount();
	public void deleteGuest(Map<String, Object> map) throws Exception;
}
