// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DeadManSwitch {

    address public owner;
    uint256 public lastCheckIn;
    uint256 public gracePeriod = 30 minutes;
    uint public total;

    enum Status {
        active,
        gracePeriodStatus,
        triggered,
        cancelled
    }

    Status public currentStatus;

    struct Beneficiary {
        address wallet;
        uint share;
    }

    Beneficiary[] public _beneficiaries;

    constructor() {
        owner = msg.sender;
        lastCheckIn = block.timestamp;
        currentStatus = Status.active;
    }

    modifier ownerOnly() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier notCancelled() {
        require(
            currentStatus != Status.cancelled,
            "Contract cancelled"
        );
        _;
    }

    receive() external payable {}

    function addBeneficiary(
        address user,
        uint share
    )
        public
        ownerOnly
        notCancelled
    {
        require(user != address(0), "Invalid address");
        require(share > 0, "Share must be > 0");

        _beneficiaries.push(
            Beneficiary({
                wallet: user,
                share: share
            })
        );

        total = 0;

        for(uint i = 0; i < _beneficiaries.length; i++) {
            total += _beneficiaries[i].share;
        }

        require(total <= 100, "Total shares exceed 100%");
    }

    function removeBeneficiary(address user)
        public
        ownerOnly
        notCancelled
    {
        bool found = false;

        for(uint i = 0; i < _beneficiaries.length; i++) {

            if(_beneficiaries[i].wallet == user) {

                found = true;

                _beneficiaries[i] =
                    _beneficiaries[
                        _beneficiaries.length - 1
                    ];

                _beneficiaries.pop();

                break;
            }
        }

        require(found, "Beneficiary not found");

        total = 0;

        for(uint i = 0; i < _beneficiaries.length; i++) {
            total += _beneficiaries[i].share;
        }
    }

    function checkIn()
        public
        ownerOnly
        notCancelled
    {
        require(
            currentStatus == Status.active,
            "Switch not active"
        );

        lastCheckIn = block.timestamp;
    }

    function updateStatus() public {

        if(currentStatus == Status.cancelled) {
            return;
        }

        if(
            block.timestamp >
            lastCheckIn + gracePeriod
        ) {
            currentStatus = Status.triggered;
        } else {
            currentStatus = Status.active;
        }
    }

    function claim()
        public
        notCancelled
    {
        updateStatus();

        require(
            currentStatus == Status.triggered,
            "Not triggered"
        );

        uint payout = 0;
        uint contractBalance = address(this).balance;

        for(uint i = 0; i < _beneficiaries.length; i++) {

            if(
                _beneficiaries[i].wallet ==
                msg.sender
            ) {

                payout =
                    contractBalance *
                    _beneficiaries[i].share /
                    100;

                // FIXED BUG
                _beneficiaries[i].share = 0;

                break;
            }
        }

        require(payout > 0, "No payout");

        payable(msg.sender).transfer(payout);
    }

    function cancel()
        public
        ownerOnly
    {
        currentStatus = Status.cancelled;
    }


    function getStatus()
        public
        view
        returns(uint8)
    {
        return uint8(currentStatus);
    }

    function getBeneficiaries()
        public
        view
        returns(
            address[] memory,
            uint[] memory
        )
    {
        address[] memory wallets =
            new address[](
                _beneficiaries.length
            );

        uint[] memory shares =
            new uint[](
                _beneficiaries.length
            );

        for(uint i = 0; i < _beneficiaries.length; i++) {

            wallets[i] =
                _beneficiaries[i].wallet;

            shares[i] =
                _beneficiaries[i].share;
        }

        return (wallets, shares);
    }

    function beneficiaryShares(
        address user
    )
        public
        view
        returns(uint)
    {
        for(uint i = 0; i < _beneficiaries.length; i++) {

            if(
                _beneficiaries[i].wallet ==
                user
            ) {
                return _beneficiaries[i].share;
            }
        }

        return 0;
    }
}