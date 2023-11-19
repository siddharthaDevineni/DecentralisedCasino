// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract DecentralisedCasino {
    mapping(address => uint256) blockNumbersToBeUsed;

    function playGame() external payable {
        uint256 blockNumberToBeUsed = blockNumbersToBeUsed[msg.sender];

        // when the player plays for the very first time, it determines the future block number
        if (blockNumberToBeUsed == 0) {
            blockNumbersToBeUsed[msg.sender] = block.number + 128;
            return;
        }

        require(
            block.number == blockNumberToBeUsed,
            "DeCasino: wrong block number"
        );
        uint256 randomNumber = block.prevrandao;

        if (randomNumber % 2 == 0) {
            uint256 winningAmount = msg.value * 2;
            (bool success, ) = msg.sender.call{value: winningAmount}("");
            require(success, "Transfer failed");
        }
    }
}
