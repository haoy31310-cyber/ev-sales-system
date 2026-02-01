package com.evsales.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Promotion {
    private Long id;
    private String title;
    private String description;
    private Integer type;
    private BigDecimal discountRate;
    private String giftDesc;
    private BigDecimal subsidyAmount;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
