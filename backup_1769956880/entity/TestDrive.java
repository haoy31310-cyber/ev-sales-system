package com.evsales.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class TestDrive {
    private Long id;
    private Long userId;
    private Long carId;
    private Long storeId;
    private LocalDateTime appointmentTime;
    private String contactName;
    private String contactPhone;
    private Integer status;
    private String adminRemark;
    private String userRemark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
