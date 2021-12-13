package homework;

import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletContext;

public class HWDAO extends JDBCConnect {
	
	//DB 연결
	public HWDAO(ServletContext application) {
		super(application);
	}
	
	//목록에 출력할 게시물을 오라클로부터 추출하기 위한 쿼리문 실행
	public List<HWDTO> selectList(Map<String, Object> map){
		List<HWDTO> bbs = new Vector<HWDTO>();
		
		String query = "SELECT * FROM board ";
		if (map.get("searchWord") != null) {
			query += " WHERE " + map.get("searchField") + " "
					+ " LIKE '%" + map.get("searchWord") + "%'";
		}
		query += " ORDER BY num DESC ";
		
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			
			while (rs.next()) {
				HWDTO dto = new HWDTO();
				
				dto.setNum(rs.getString("num"));
				dto.setTitle(rs.getString("title"));
				dto.setContent(rs.getString("content"));
				dto.setPostdate(rs.getDate("postdate"));
				dto.setId(rs.getString("id"));
				dto.setVisitcount(rs.getString("visitcount"));
				
				bbs.add(dto);
			}
		}
		catch (Exception e) {
			System.out.println("게시물 조회 중 예외 발생");
			e.printStackTrace();
		}
		
		return bbs;
	}
	
	/*
	board테이블에 저장된 게시물의 개수를 카운트하기 위한 메서드
	카운트 한 결과값을 통해 목록에서 게시물의 순번을 출력한다.
	 */
	public int selectCount(Map<String, Object> map) {
		//카운트 변수
		int totalCount = 0;
		
		//쿼리문
		String query = "SELECT COUNT(*) FROM board ";
		
		//검색어가 있는 경우 where절을 동적으로 추가한다.
		if (map.get("searchWord") != null) {
			query += " WHERE " + map.get("searchField") + " "
					+ " LIKE '%" + map.get("searchWord") + "%'";
		}
		
		try {
			stmt = con.createStatement();
			//select 쿼리문을 실행 후 ResultSet객체를 반환받음
			rs = stmt.executeQuery(query);
			rs.next();
			totalCount = rs.getInt(1);
		}
		catch (Exception e) {
			System.out.println("게시물 수를 구하는 중 예외 발생");
			e.printStackTrace();
		}
		
		return totalCount;
	}
	
	//상세보기를 위해 특정 일련번호에 해당하는 게시물을 인출
	public HWDTO selectView(String num) {
		HWDTO dto = new HWDTO();
		
		//join을 이용해서 member테이블의 name컬럼까지 가져온다.
		String query = "SELECT B.*, M.name "
				+ " FROM member M INNER JOIN board B "
				+ " ON M.id=B.id "
				+ " WHERE num=?";
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, num);
			rs = psmt.executeQuery();
			
			//일련번호는 중복되지 않으므로 if문에서 처리하면 된다.
			if (rs.next()) { //ResultSet에서 커서를 이동시켜 레코드를 읽은 후
				//DTO객체에 레코드의 내용을 추가한다.
				dto.setNum(rs.getString(1));
				dto.setTitle(rs.getString(2));
				dto.setContent(rs.getString("content"));
				dto.setPostdate(rs.getDate("postdate")); //날짜타입이므로 getDate()를 사용함
				dto.setId(rs.getString("id"));
				dto.setVisitcount(rs.getString(6));
				dto.setName(rs.getString("name"));
			}
		}
		catch (Exception e) {
			System.out.println("게시물 상세보기 중 예외 발생");
			e.printStackTrace();
		}
		
		return dto;
	}
	
	//게시물의 조회수를 1 증가 시킨다.
	public void updateVisitCount(String num) {
		//visitcount 컬럼은 number 타입이므로 덧셈이 가능하다.
		String query = "UPDATE board SET "
				+ " visitcount=visitcount+1 "
				+ " WHERE num=?";
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, num);
			psmt.executeQuery();
		}
		catch (Exception e) {
			System.out.println("게시물 조회수 증가 중 예외 발생");
			e.printStackTrace();
		}
	}
	
	//사용자가 입력한 내용을 board테이블에 insert 처리하는 메서드
	public int insertWrite(HWDTO dto) {
		//입력결과 확인용 변수
		int result = 0;
		
		try {
			//인파라미터가 있는 쿼리문 작성(동적 쿼리문)
			String query = "INSERT INTO board ( "
					+ " num, title, content, id, visitcount) "
					+ " VALUES ( "
					+ " seq_board_num.NEXTVAL, ?, ?, ?, 0)";
			
			//동적 쿼리문 실행을 위한 객체 생성
			psmt = con.prepareStatement(query);
			//순서대로 인파라미터 설정
			psmt.setString(1, dto.getTitle());
			psmt.setString(2, dto.getContent());
			psmt.setString(3, dto.getId());
			
			//쿼리문 실행 : 입력에 성공한다면 1이 반환된다. 실패시 0반환
			result = psmt.executeUpdate();
		}
		catch (Exception e) {
			System.out.println("게시물 입력 중 예외 발생");
			e.printStackTrace();
		}
		
		return result;
	}
	
	//DTO객체를 받아 게시물 삭제처리
	public int deletePost(HWDTO dto) {
		int result = 0;
		
		try {
			//쿼리문 작성
			String query = "DELETE FROM board WHERE num=?";
			
			//쿼리 실행을 위한 객체 생성 및 인파라미터 설정
			psmt = con.prepareStatement(query);
			psmt.setString(1, dto.getNum());
			
			//쿼리 실행
			result = psmt.executeUpdate();
		}
		catch (Exception e) {
			System.out.println("게시물 삭제 중 예외 발생");
			e.printStackTrace();
		}
		
		return result;
	}
	
	//게시물 수정 : 수정할 내용을 DTO객체에 저장 후 매개변수로 전달
	public int updateEdit(HWDTO dto) {
		int result = 0;
		
		try {
			//update를 위한 쿼리문
			String query = "UPDATE board SET "
					+ " title=?, content=? "
					+ " WHERE num=?";
			
			//쿼리 실행을 위한 객체 생성
			psmt = con.prepareStatement(query);
			//인파라미터 설정
			psmt.setString(1, dto.getTitle());
			psmt.setString(2, dto.getContent());
			psmt.setString(3, dto.getNum());
			
			//쿼리 실행
			result = psmt.executeUpdate();
		}
		catch (Exception e) {
			System.out.println("게시물 수정 중 예외 발생");
			e.printStackTrace();
		}
		
		return result;
	}
	
	//게시판의 페이징 처리를 위한 메서드
	public List<HWDTO> selectListPage(Map<String, Object> map) {
		List<HWDTO> bbs = new Vector<HWDTO>();
		
		//3개의 쿼리문을 통한 페이지 처리
		String query = " SELECT * FROM ( "
				+ " 		SELECT Tb.*, ROWNUM rNum FROM ( "
				+ " 			SELECT * FROM board ";
		
		//검색 조건 추가(검색어가 있는 경우에만 where절이 추가됨)
		if (map.get("searchWord") != null) {
			query += " WHERE " + map.get("searchField")
				+ " LIKE '%" + map.get("searchWord") + "%' ";
		}
		
		query += " 		ORDER BY num DESC "
				+ "		) Tb "
				+ " ) "
				+ " WHERE rNum BETWEEN ? AND ?";
		/* JSP에서 계산된 게시물의 구간을 인파라미터로 처리함 */
		
		try {
			//쿼리 실행을 위한 객체 생성
			psmt = con.prepareStatement(query);
			//인파라미터 설정 : 구간을 위한 start, end를 설정함
			psmt.setString(1, map.get("start").toString());
			psmt.setString(2, map.get("end").toString());
			//쿼리 실행
			rs = psmt.executeQuery();
			//select한 게시물의 개수만큼 반복함
			while (rs.next()) {
				HWDTO dto = new HWDTO();
				
				dto.setNum(rs.getString("num"));
				dto.setTitle(rs.getString("title"));
				dto.setContent(rs.getString("content"));
				dto.setPostdate(rs.getDate("postdate"));
				dto.setId(rs.getString("id"));
				dto.setVisitcount(rs.getString("visitcount"));
				
				bbs.add(dto);
			}
		}
		catch (Exception e) {
			System.out.println("게시물 조회 중 예외 발생");
			e.printStackTrace();
		}
		
		//목록 반환
		return bbs;
	}
	
	//아이디 찾기
	public String findId(String name) {
		String id = "";
		
		String query = "SELECT id FROM member WHERE name=?";
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, name);
			
			rs = psmt.executeQuery();
			
			if (rs.next()) {
				id = rs.getString(1);
			}
		}
		catch (Exception e) {
			System.out.println("아이디를 찾는 중 예외 발생");
			e.printStackTrace();
		}
		
		return id;
	}
	
	//비밀번호 찾기
	public String findPw(String id, String name) {
		String pw = "";
		
		String query = "SELECT pass FROM member WHERE id=? AND name=?";
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, id);
			psmt.setString(2, name);
			
			rs = psmt.executeQuery();
			
			if (rs.next()) {
				pw = rs.getString(1);
			}
		}
		catch (Exception e) {
			System.out.println("비밀번호를 찾는 중 예외 발생");
			e.printStackTrace();
		}
		
		return pw;
	}
}
