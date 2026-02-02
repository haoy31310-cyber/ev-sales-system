package com.evsales.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class TestDrive {
    private Long id;
    private Long userId;        // 用户ID
    private Long carId;         // 车辆ID
    private String store;       // 试驾门店
    private LocalDateTime driveTime; // 试驾时间
    private String status;      // 状态: PENDING, APPROVED, REJECTED, COMPLETED
    private String notes;       // 备注
    private LocalDateTime applyTime; // 申请时间
    private LocalDateTime reviewTime; // 审核时间
    private String reviewNotes; // 审核意见
}
