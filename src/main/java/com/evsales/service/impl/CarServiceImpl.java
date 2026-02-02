package com.evsales.service.impl;

import com.evsales.entity.Car;
import com.evsales.mapper.CarMapper;
import com.evsales.service.CarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CarServiceImpl implements CarService {
    
    @Autowired
    private CarMapper carMapper;
    
    @Override
    public List<Car> getAllCars() {
        return carMapper.findAll();
    }
    
    @Override
    public Car getCarById(Long id) {
        return carMapper.findById(id);
    }
    
    @Override
    public List<Car> searchCars(String brand, Double minPrice, Double maxPrice) {
        if (brand != null && !brand.isEmpty()) {
            return carMapper.findByBrand(brand);
        }
        return carMapper.findAll();
    }
    
    @Override
    public List<Car> searchCarsFull(String brand, Double minPrice, Double maxPrice, 
                                  Integer minRange, Integer maxRange) {
        List<Car> allCars = carMapper.findAll();
        return allCars.stream()
            .filter(car -> brand == null || brand.isEmpty() || brand.equals(car.getBrand()))
            .filter(car -> minPrice == null || car.getPrice() >= minPrice)
            .filter(car -> maxPrice == null || car.getPrice() <= maxPrice)
            .filter(car -> minRange == null || car.getRangeKm() >= minRange)
            .filter(car -> maxRange == null || car.getRangeKm() <= maxRange)
            .collect(Collectors.toList());
    }
    
    @Override
    @Transactional
    public boolean addCar(Car car) {
        car.setStatus(1);
        return carMapper.insert(car) > 0;
    }
    
    @Override
    @Transactional
    public boolean updateCar(Car car) {
        return carMapper.update(car) > 0;
    }
    
    @Override
    @Transactional
    public boolean deleteCar(Long id) {
        return carMapper.deleteById(id) > 0;
    }
    
    @Override
    public List<Car> getLowStockCars(Integer threshold) {
        return carMapper.findLowStock(threshold == null ? 5 : threshold);
    }
    
    @Override
    public List<String> getAllBrands() {
        return carMapper.findAllBrands();
    }
}
