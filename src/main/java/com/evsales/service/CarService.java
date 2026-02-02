package com.evsales.service;

import com.evsales.entity.Car;
import java.util.List;

public interface CarService {
    List<Car> getAllCars();
    Car getCarById(Long id);
    List<Car> searchCars(String brand, Double minPrice, Double maxPrice);
    List<Car> searchCarsFull(String brand, Double minPrice, Double maxPrice, 
                           Integer minRange, Integer maxRange);
    boolean addCar(Car car);
    boolean updateCar(Car car);
    boolean deleteCar(Long id);
    List<Car> getLowStockCars(Integer threshold);
    List<String> getAllBrands();
}
