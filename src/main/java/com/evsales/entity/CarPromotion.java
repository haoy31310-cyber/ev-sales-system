package com.evsales.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class CarPromotion {
    private Long id;
    private Long carId;
    private Long promotionId;
    private LocalDateTime createTime;
}
