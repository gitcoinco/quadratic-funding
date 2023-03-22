pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol"; 
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract quadFund is Ownable {
    using SafeMath for uint256;
    struct FundingRound {
        Fund[4] funds;
        uint256 duration;
    }
    struct Requester {
        string name;
        uint256 timesRequested;
    }
    struct Fund {
        string name;
        address payable owner;
        uint256 balance;
        uint256 numberOfFundingRounds;
        uint256 individualContributions;
    }
    //Amount in fund from fees collected from donations
    uint256 quadraticFund;
    //Names of causes displayed during funding rounds
    string public causeA;
    string public causeB;
    string public causeC;
    string public causeD;
    //Balance of each cause's donations on the platoform
    uint256 public balanceCauseA;
    uint256 public balanceCauseB;
    uint256 public balanceCauseC;
    uint256 public balanceCauseD;
    //Number of contributors to each cause
    uint256 public contributorCountA;
    uint256 public contributorCountB;
    uint256 public contributorCountC;
    uint256 public contributorCountD;
    //Amount of time left in the funding round
    uint256 public endTime;
    bool public fundingRoundOver = true;
    //make a list of Requestors so repeat users can be identified
    address[] requestorList;
    //Queue of funds waiting to be funded
    Fund[] fundsQueue;
    //mapping of funds to their addresses. Edit: not sure if this is necessary
    //mapping(uint256 => address[]) public queueNumber;

    //mapping of Requestors to their addresses
    mapping(address => Requester) public requesters;
    uint256 public fundingTimeLeft;
    //Events emitted for Funds being created, funding rounds beginning and new contributions being made to causes
    event FundCreated(string name, address owner);
    event FundingRoundStart(Fund fund1, Fund fund2, Fund fund3, Fund fund4);
    event newDonation(address donor, uint256 amount);

    function createFund(string memory _name, address _owner) public {
        Fund memory newFund = Fund(_name, payable(_owner), 0, 0, 0);
        //Check to see if Requester exists, if so add to their timesFunded, if not create new contributor
        if (requesters[_owner].timesRequested == 0) {
            Requester memory newRequester = Requester(_name, 1);
            requesters[_owner] = newRequester;
        } else {
            requesters[_owner].timesRequested += 1;
        }
        //Add the new fund to the queue
        fundsQueue.push(newFund);
        emit FundCreated(_name, _owner);
        //If the queue is at 4 minimum, start the funding round
        if (fundsQueue.length == 4) {
            startFundingRound();
        }

    }

    function startFundingRound() private  {
        // Define the four funds who will accept donations this funding round
        Fund[4] memory selectedFunds = [        
            fundsQueue[0],
            fundsQueue[1],
            fundsQueue[2],
            fundsQueue[3]
        ];
        FundingRound memory fundingRound = FundingRound({
            funds: selectedFunds,
            duration: block.timestamp + 3 minutes
        });
        // Update the state variables to reflect the new funding round
        causeA = fundingRound.funds[0].name;
        causeB = fundingRound.funds[1].name;
        causeC = fundingRound.funds[2].name;
        causeD = fundingRound.funds[3].name;
        fundingRoundOver = false;
        endTime = fundingRound.duration;
        emit FundingRoundStart(fundingRound.funds[0], fundingRound.funds[1], fundingRound.funds[2], fundingRound.funds[3]);
    }
    function donateToCauseA () public payable {
        //Check to see if the funding round is over. If so, return the function
        require(fundingRoundOver == false, "Funding round is over");
        //Check to see if time has already expired for funding. If so end the funding round immediately and return the function
        if (block.timestamp >= endTime) {
            endFundingRound();
            return;
        }
        // Donations must be less than 0
        require(msg.value > 0, "Amount must be greater than 0");
        //Make msg.value a uint256
        uint256 _amount = uint256(msg.value);

        //uint256 _amount = msg.value;
        //Transfer the donation to the smart contract
        payable(address(this)).transfer(_amount);
        //take a fee of 1% of the donation
        uint256 fee = _amount.div(10);
        uint256 amountAfterFee = _amount.sub(fee);
        //add the amount to the balance of the cause
        balanceCauseA = balanceCauseA.add(amountAfterFee);
        //add the amount to the smart contract's total for funding the next project
        quadraticFund = quadraticFund.add(fee);
        //Add to tally of individual contributors for this cause
        contributorCountA++;
        //emit event for a new donation being made
        emit newDonation(msg.sender, _amount);
    }
    function donateToCauseB () public payable {
        require(fundingRoundOver == false, "Funding round is over");
        if (block.timestamp >= endTime) {
          endFundingRound();
          return;
        }
        uint256 _amount = msg.value;
        require(_amount > 0, "Amount must be greater than 0");
        payable(address(this)).transfer(_amount);
        uint256 fee = _amount.div(10);
        uint256 amountAfterFee = _amount.sub(fee);
        balanceCauseB = balanceCauseB.add(amountAfterFee);
        quadraticFund = quadraticFund.add(fee);
        contributorCountB++;
        emit newDonation(msg.sender, _amount);
    }
    function donateToCauseC () public payable {
      require(fundingRoundOver == false, "Funding round is over");
      if (block.timestamp >= endTime) {
          endFundingRound();
          return;
      }
      uint256 _amount = msg.value;
      require(_amount > 0, "Amount must be greater than 0");
      payable(address(this)).transfer(_amount);
      uint256 fee = _amount.div(10);
      uint256 amountAfterFee = _amount.sub(fee);
      balanceCauseC = balanceCauseC.add(amountAfterFee);
      quadraticFund = quadraticFund.add(fee);
      contributorCountC++;
      emit newDonation(msg.sender, _amount);
    }
    function donateToCauseD () public payable {
        require(fundingRoundOver == false, "Funding round is over");
      if (block.timestamp >= endTime) {
          endFundingRound();
          return;
      }
      uint256 _amount = msg.value;
      require(_amount > 0, "Amount must be greater than 0");
      payable(address(this)).transfer(_amount);
      uint256 fee = _amount.div(10);
      uint256 amountAfterFee = _amount.sub(fee);
      balanceCauseD = balanceCauseD.add(amountAfterFee);
        quadraticFund = quadraticFund.add(fee);
        contributorCountD++;
        emit newDonation(msg.sender, _amount);
    }
    function checkDuration () public {
     require (block.timestamp >= endTime, "Countdown has not ended");
     //If the countdown has ended, end the funding round
     endFundingRound(); 
    }
    function endFundingRound() public onlyOwner {       
        //send 80% the quadratic fund's balance accoring to the quadratic funding formula
        //send the funds to the owners of the funds
        distributeFunds();
        //reset the names of causes in the funding round display
        causeA = "";
        causeB = "";
        causeC = "";
        causeD = "";
        //remove the previous round's funds from the queue
        clearQueue();
        //reset the countdown
        endTime = 0;
        fundingRoundOver = true;
        //If there are 4 more causes in queue, begin the next round of fundraising immediately.
        if (fundsQueue.length == 4) {
            startFundingRound();
        }
    }
    function distributeFunds () public onlyOwner {
        //payout 80% of the quadratic fund to the owners of the funds
        uint256 payOut= quadraticFund * 80/100;
        //calculate the total number of contributors
        uint256 totalContributors = contributorCountA + contributorCountB + contributorCountC + contributorCountD;
        //calculate the percentage of the total contributors each contributor is
        uint256 contributorPercentageA = contributorCountA / totalContributors;
        uint256 contributorPercentageB = contributorCountB / totalContributors;
        uint256 contributorPercentageC = contributorCountC / totalContributors;
        uint256 contributorPercentageD = contributorCountD / totalContributors;
        //calculate the amount of funds each contributor gets
        uint256 distributionA = payOut * contributorPercentageA;
        uint256 distributionB = payOut * contributorPercentageB;
        uint256 distributionC = payOut * contributorPercentageC;
        uint256 distributionD = payOut * contributorPercentageD;
        //send the funds to the owners of the funds
        Fund(fundsQueue[0].name, fundsQueue[0].owner, fundsQueue[0].balance, fundsQueue[0].numberOfFundingRounds, fundsQueue[0].individualContributions).owner.transfer(distributionA + balanceCauseA);
        Fund(fundsQueue[1].name, fundsQueue[1].owner, fundsQueue[1].balance, fundsQueue[1].numberOfFundingRounds, fundsQueue[1].individualContributions).owner.transfer(distributionB + balanceCauseB);
        Fund(fundsQueue[2].name, fundsQueue[2].owner, fundsQueue[2].balance, fundsQueue[2].numberOfFundingRounds, fundsQueue[2].individualContributions).owner.transfer(distributionC + balanceCauseC);
        Fund(fundsQueue[3].name, fundsQueue[3].owner, fundsQueue[3].balance, fundsQueue[3].numberOfFundingRounds, fundsQueue[3].individualContributions).owner.transfer(distributionD + balanceCauseD);

        //reset the balances of the causes
        balanceCauseA = 0;
        balanceCauseB = 0;
        balanceCauseC = 0;
        balanceCauseD = 0;
    }
    function clearQueue () public onlyOwner {
        //remove the previous round's funds from the queue
        delete fundsQueue[0];
        delete fundsQueue[1];
        delete fundsQueue[2];
        delete fundsQueue[3];
    }
}