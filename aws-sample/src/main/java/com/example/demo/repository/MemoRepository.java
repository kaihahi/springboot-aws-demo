package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.domain.Memo;

public interface MemoRepository extends JpaRepository<Memo, Long>{

}
