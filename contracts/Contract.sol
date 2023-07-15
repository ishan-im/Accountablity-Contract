// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract GoalSettingContract {

    struct Task{

        string description;
        bool   isCompleted;

    }

    Task[] public tasks;
    uint256 public deposit;

    address public owner;


    event TaskCreated(uint256 taskId,string description);
    event TaskCompleted(uint256 id);
    event DespositWithdrawn(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }



    constructor() {
        owner = msg.sender;
    }


    function createTask(string memory _description) public onlyOwner {

        tasks.push(Task(_description, false));
        emit TaskCreated(tasks.length -1,_description);

    }


    function depositFunds() public payable onlyOwner {

        require(msg.value>0, "Deposit amount must be greater than 0.");

        deposit += msg.value;

    }

    function withdrawDepositSafely() public onlyOwner {

        require(deposit>0, "Deposit amount must be greater than 0."); 

        uint256 amount = deposit;
        payable(owner).transfer(amount);
        deposit = 0;
        
        emit DespositWithdrawn(amount);

    }



    function allTasksCompleted() private view returns(bool){

        for(uint256 i=0;i<tasks.length;i++){

            if(!tasks[i].isCompleted){
                return false;
            }

        }

        return true;

    }

    function clearTask () private{
        delete tasks;
    }


    function completeTask(uint256 _id) public onlyOwner {

        require(_id<tasks.length, "Invalid task id.");
        require(!tasks[_id].isCompleted, "Task is already completed.");

        tasks[_id].isCompleted = true;

        emit TaskCompleted(_id);

        if(allTasksCompleted()){
           
            uint256 amount = deposit;
            payable(owner).transfer(amount);
            deposit = 0;
            emit DespositWithdrawn(amount);
            clearTask();

        }

    }



    function getTaskCount() public view returns(uint256){

        return tasks.length;

    }

    function getDeposit() public view returns(uint256){

        return deposit;

    }

    function getTasks() public view returns(Task[] memory){

       return tasks;

    }
}