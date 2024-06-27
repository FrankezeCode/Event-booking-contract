// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract eventBooking{

    struct Event {
    address organizer;
    string name;
    uint date;
    uint price;
    uint ticketCount;
    uint ticketRemaining;
    } 
    mapping(uint=>Event) public events;//details of all the event been created
    mapping(address=>mapping(uint => uint)) public tickets;//
    uint public eventId;


    function createEvent(string calldata _name,uint _date, uint _price, uint _ticketCount) public {
        require(block.timestamp < _date, "You cant create event for past day");
        require(_ticketCount > 0, "Ticket count must be grater than Zero");
        events[eventId] = Event(msg.sender,_name, _date, _price,_ticketCount, _ticketCount);
        eventId++;      
    }

    function buyTicket(uint id, uint quantity) public payable {
        require(events[id].date != 0, "Event does not exist");
        require(events[id].date > block.timestamp, "Event has Ended");
        Event storage _event = events[id];
        require(msg.value == _event.price*quantity, "Not enough ether" );
        require(_event.ticketRemaining>=quantity, "Not enough Ticket left");
        _event.ticketRemaining-=quantity;
        
         tickets[msg.sender][id]+=quantity;
    }

    function transferTicket(uint id, uint quantity, address to) public{
        require(events[id].date != 0, "Event does not exist");
        require(events[id].date > block.timestamp, "Event has Ended");
        require(tickets[msg.sender][id]>= quantity , "You do not have enough tickets to transfer");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;


    }
}
