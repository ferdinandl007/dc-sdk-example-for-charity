pragma solidity ^0.4.19;

import "./core/oneStepGame.sol";



contract myDAppGame is oneStepGame {

    /**
    @notice constructor
    @param _token address of token contract
    @param _ref address of referrer contract
    @param _gameWL address of games whitelist contract
    @param _playerWL address of players whitelist contract
    @param _rsa address of rsa contract
    */
    constructor (
        ERC20Interface _token,
        RefInterface _ref,
        GameWLinterface _gameWL,
        PlayerWLinterface _playerWL,
        RSA _rsa
    )
        oneStepGame(_token, _ref, _gameWL, _playerWL, _rsa) public
    {
        developer = 0x42;
        
        config = Config({
            maxBet: 100 ether,
            minBet: 1,
            gameDevReward: 25,
            bankrollReward: 25,
            platformReward: 25,
            refererReward: 25
        });   
    }

   /** 
    @notice interface for check game data
    @param _gameData Player's game data
    @param _bet Player's bet
    @return result boolean
    */
    function checkGameData(uint[] _gameData, uint _bet) public view returns (bool) {
        uint playerNumber = _gameData[0];
        require(_bet >= config.minBet && _bet <= config.maxBet);
       // require(playerNumber > 0 && playerNumber < 64226);
        return true;
    }

    /** 
    @notice interface for game logic
    @param _gameData Player's game data
    @param _bet Player's bet
    @param _sigseed random seed for generate rnd
    */
    function game(uint[] _gameData, uint _bet, bytes _sigseed) public view returns(bool _win, uint _amount) {   
        checkGameData(_gameData, _bet);
        //gameData[0] - player number  
        uint uintSeed = bytesToUint(_sigseed);
        uint _playerNumber = uintSeed % 100;
        uint _profit = getProfit(_gameData, _bet);

        // Game logic
        if (_playerNumber > 55) {
            // player win profit
            return(true, _profit);
        } else {
            // player lose bet
            return(false, _bet);
        }
    }

    function bytesToUint(bytes b) public returns (uint256){
        uint256 number;
        for(uint i = 0; i < b.length; i++){
            number = number + uint(b[i])*(2**(8*(b.length-(i+1))));
        }
        return number;
    }

    /** 
    @notice profit calculation
    @param _gameData Player's game data
    @param _bet Player's bet
    @return profit
    */
    function getProfit(uint[] _gameData, uint _bet) public pure returns(uint _profit) {
        uint _playerNumber = _gameData[0];
        _profit = (_bet.mul(uint(65535).mul(10000).div(_playerNumber)).div(10000)).sub(_bet);
    }
}