package com.example.demo.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.domain.Memo;
import com.example.demo.repository.MemoRepository;

@RestController
@RequestMapping("/api/memos")
public class MemoController {
	private final MemoRepository memoRepository;

    public MemoController(MemoRepository memoRepository) {
        this.memoRepository = memoRepository;
    }

    @GetMapping
    public List<Memo> getAll() {
        return memoRepository.findAll();
    }

    @PostMapping
    public Memo create(@RequestBody Memo memo) {
        return memoRepository.save(memo);
    }

}
