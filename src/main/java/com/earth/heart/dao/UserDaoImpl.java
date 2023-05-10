package com.earth.heart.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.earth.heart.domain.User;

@Repository
public class UserDaoImpl implements UserDao {
	@Autowired
	DataSource ds;
	
	final int FAIL = 0;

	@Override
	public User selectUser(String id) {
		User user = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = ds.getConnection();
			String sql = "select * from t_user where id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				user = new User();
				user.setId(rs.getString(1));
				user.setPwd(rs.getString(2));
				user.setName(rs.getString(3));
				user.setEmail(rs.getString(4));
				user.setBirth(new Date(rs.getDate(5).getTime()));
				user.setSns(rs.getString(6));
				user.setReg_date(new Date(rs.getTimestamp(7).getTime()));
			}			
		} catch (SQLException e) { e.printStackTrace();	
		
		} finally {
//			if (rs != null) { try { rs.close(); } catch (SQLException e) { e.printStackTrace();} }
//			if (pstmt != null) { try { pstmt.close(); } catch (SQLException e) { e.printStackTrace();} }
//			if (conn != null) { try { conn.close(); } catch (SQLException e) { e.printStackTrace();} }
			close(rs, pstmt, conn);
		}
		
		
		return user;
	}

	private void close(AutoCloseable...closeables) {
		for (AutoCloseable autoCloseable : closeables) {
			if (autoCloseable != null) try { autoCloseable.close(); } catch (Exception e) { e.printStackTrace(); } 
		}		
	}

	@Override
	public int deleteUser(String id) {
		int rowCnt = FAIL;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = ds.getConnection();
			String sql = "delete from t_user where id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);	
			return pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			return FAIL;
		} finally {
			close(pstmt, conn);
		}			
	}

	@Override
	public void deleteAll() throws SQLException {
		Connection conn  = ds.getConnection();
		String sql = "delete from t_user";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();		
	}

	@Override
	public int updateUser(User user) {
		int rowCnt = FAIL;
		// try-with-resources
		
		String sql = "update t_user "
				+ "set pwd = ?, name = ?, email = ?,  birth = ?, sns = ?, reg_date = ? "
				+ "where id = ?";
		
		try(
				Connection conn = ds.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
		) {		
			pstmt.setString(1, user.getPwd());
			pstmt.setString(2, user.getName());
			pstmt.setString(3, user.getEmail());
			pstmt.setDate(4, new java.sql.Date(user.getBirth().getTime()));
			pstmt.setString(5, user.getSns());
			pstmt.setDate(6, new java.sql.Date(user.getReg_date().getTime()));
			pstmt.setString(7, user.getId());
			rowCnt = pstmt.executeUpdate();			
		} catch (SQLException e) {
			e.printStackTrace();
			return FAIL;
		}
	
		return rowCnt;
	}

	@Override
	public int insertUser(User user) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = ds.getConnection();
			/*
			 * 인파라미터에는 물음표를 사용함
			 * 정확한 값을 나중에 채워주겠다는 의미임 
			 */
			String sql = 
				"INSERT INTO t_user VALUES(?, ?, ?, ?, ?, ?,now())";
			pstmt = conn.prepareStatement(sql);
			/*
			 * 인파라미터 설정시 데이터 타입에 맞는 set메서드를 사용함
			 * set메서드는 데이터 타입별로 다양하게 준비되어 있음 
			 */
			pstmt.setString(1, user.getId());
			pstmt.setString(2, user.getPwd());
			pstmt.setString(3, user.getName());
			pstmt.setString(4, user.getEmail());
			pstmt.setDate(5, new java.sql.Date(user.getBirth().getTime()));
			pstmt.setString(6, user.getSns());
			
			return pstmt.executeUpdate();			//insert, update, delete
			
		} catch (SQLException e) {
			e.printStackTrace();
			return FAIL;
		} finally {
			close(pstmt, conn);
		}
		
	}

}







