// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TextbookLending {
    struct Book {
        uint id;
        string title;
        address lender;
        address borrower;
        bool isAvailable;
        uint dueDate;
    }

    mapping(uint => Book) public books;
    uint public nextBookId;
    
    event BookListed(uint bookId, string title, address lender);
    event BookBorrowed(uint bookId, address borrower, uint dueDate);
    event BookReturned(uint bookId, address borrower);

    function listBook(string memory title) public {
        books[nextBookId] = Book(nextBookId, title, msg.sender, address(0), true, 0);
        emit BookListed(nextBookId, title, msg.sender);
        nextBookId++;
    }

    function borrowBook(uint bookId, uint durationInDays) public {
        require(books[bookId].isAvailable, "Book is not available.");
        books[bookId].borrower = msg.sender;
        books[bookId].isAvailable = false;
        books[bookId].dueDate = block.timestamp + (durationInDays * 1 days);
        emit BookBorrowed(bookId, msg.sender, books[bookId].dueDate);
    }

    function returnBook(uint bookId) public {
        require(books[bookId].borrower == msg.sender, "You are not the borrower of this book.");
        books[bookId].borrower = address(0);
        books[bookId].isAvailable = true;
        books[bookId].dueDate = 0;
        emit BookReturned(bookId, msg.sender);
    }

    function getBookDetails(uint bookId) public view returns (Book memory) {
        return books[bookId];
    }
}
