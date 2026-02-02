package com.evsales.mapper;

import com.evsales.entity.TestDrive;
import org.apache.ibatis.annotations.*;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface TestDriveMapper {
    
    // 查询所有试驾预约
    @Select("SELECT * FROM test_drive ORDER BY apply_time DESC")
    List<TestDrive> findAll();
    
    // 根据用户ID查询
    @Select("SELECT * FROM test_drive WHERE user_id = #{userId} ORDER BY apply_time DESC")
    List<TestDrive> findByUserId(Long userId);
    
    // 根据状态查询
    @Select("SELECT * FROM test_drive WHERE status = #{status} ORDER BY apply_time DESC")
    List<TestDrive> findByStatus(String status);
    
    // 根据ID查询
    @Select("SELECT * FROM test_drive WHERE id = #{id}")
    TestDrive findById(Long id);
    
    // 插入试驾预约
    @Insert("INSERT INTO test_drive (user_id, car_id, store, drive_time, status, notes) " +
            "VALUES (#{userId}, #{carId}, #{store}, #{driveTime}, #{status}, #{notes})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(TestDrive testDrive);
    
    // 更新试驾状态（管理员审核）
    @Update("UPDATE test_drive SET status = #{status}, review_time = NOW(), review_notes = #{reviewNotes} WHERE id = #{id}")
    int updateStatus(@Param("id") Long id, @Param("status") String status, @Param("reviewNotes") String reviewNotes);
    
    // 更新试驾信息
    @Update("UPDATE test_drive SET store = #{store}, drive_time = #{driveTime}, notes = #{notes} WHERE id = #{id}")
    int update(TestDrive testDrive);
    
    // 删除试驾预约
    @Delete("DELETE FROM test_drive WHERE id = #{id}")
    int deleteById(Long id);
    
    // 统计待审核的试驾申请
    @Select("SELECT COUNT(*) FROM test_drive WHERE status = 'PENDING'")
    int countPending();
}
