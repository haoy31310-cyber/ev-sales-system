package com.evsales.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Promotion {
    private Long id;
    private String title;           // 活动标题
    private String description;     // 活动描述
    private String discountType;    // 折扣类型: percentage(百分比), fixed(固定金额), gift(赠品)
    private Double discountValue;   // 折扣值
    private String giftDescription; // 赠品描述
    private LocalDateTime startTime; // 开始时间
    private LocalDateTime endTime;   // 结束时间
    private String status;          // 状态: ACTIVE, INACTIVE
    private LocalDateTime createTime;
}
