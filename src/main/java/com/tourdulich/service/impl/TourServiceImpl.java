package com.tourdulich.service.impl;

import com.tourdulich.dao.TourDAO;
import com.tourdulich.dao.impl.TourDAOImpl;
import com.tourdulich.model.Tour;
import com.tourdulich.service.TourService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public class TourServiceImpl implements TourService {
    private static final Logger logger = LoggerFactory.getLogger(TourServiceImpl.class);
    
    private final TourDAO tourDAO;
    
    public TourServiceImpl() {
        this.tourDAO = new TourDAOImpl();
    }
    

    public TourServiceImpl(TourDAO tourDAO) {
        this.tourDAO = tourDAO;
    }

    @Override
    public List<Tour> getTopNewestTours(int limit) {
        logger.debug("Lấy top {} tour mới nhất", limit);
        return tourDAO.findTopNewest(limit);
    }

    @Override
    public List<Tour> getAllActiveTours() {
        logger.debug("Lấy tất cả tour đang hoạt động");
        return tourDAO.findAllActive();
    }

    @Override
    public Optional<Tour> getTourById(Long id) {
        logger.debug("Lấy tour theo ID: {}", id);
        return tourDAO.findById(id);
    }

    @Override
    public List<Tour> searchTours(String keyword, String location, BigDecimal minPrice, BigDecimal maxPrice) {
        logger.debug("Tìm kiếm tour: keyword={}, location={}, price={}-{}", 
                    keyword, location, minPrice, maxPrice);
        return tourDAO.search(keyword, location, minPrice, maxPrice);
    }

    @Override
    public List<Tour> getToursByLocation(String location) {
        logger.debug("Tìm tour theo địa điểm: {}", location);
        return tourDAO.searchByLocation(location);
    }

    @Override
    public long getTotalActiveTours() {
        return tourDAO.countActive();
    }
}



