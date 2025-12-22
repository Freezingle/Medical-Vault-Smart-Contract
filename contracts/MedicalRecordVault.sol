// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

contract MedicalRecordVault{

    struct Record {
        string ipsHash; //file locaiton on ipfs, recordid
        bytes32 encryptedKeyHash; //hash of the encrypted key
        bool exists;
    }
    mapping(address => mapping(uint256=>Record)) private records;  

    //mapping doctors access
    mapping(address=>mapping(uint256=>mapping(address=>bool))) private access;

    //patient record count
    mapping(address=>uint256) private recordCount;

    event RecordCreated(address indexed patient, uint256 indexed recordId, string ipsHash);
    event AccessGranted(address indexed patient, address indexed doctor, uint256 indexed recordId);
    event AccessRevoked(address indexed patient, address indexed doctor, uint256 indexed recordId);
    event RecordAccessed(address indexed patient, address indexed doctor, uint256 indexed recordId,uint256 timestamp);

    //helper funciton to check if record exists
    modifier recordExists(address patient, uint256 recordId){
        require(records[patient][recordId].exists, "Record does not exist");
        _;
    }

    //create a new record 
    function createRecord(string calldata ipsHash, bytes32 encryptedKeyHash) external returns(uint256){
        uint256 recordId = recordCount[msg.sender];
        records[msg.sender][recordId]= Record(ipsHash,encryptedKeyHash,true);
        recordCount[msg.sender]++;
        return recordId;
    }
    
    //grant doctor access
    function grantAccess(uint256 recordId, address doctor) external recordExists(msg.sender,recordId){
        access[msg.sender][recordId][doctor]=true;
        emit AccessGranted(msg.sender,doctor,recordId);
    }
    //revoke doctor access 
    function revokeAccess(uint256 recordId, address doctor) external recordExists(msg.sender,recordId){
        access[msg.sender][recordId][doctor]= false;
        emit AccessRevoked(msg.sender,doctor,recordId);
    }
    //doctor fetching record metadata
    function getRecord(address patient, uint256 recordId) external recordExists(patient,recordId) returns (string memory, bytes32){
        require(access[patient][recordId][msg.sender], "Access denied");

        emit RecordAccessed(patient, msg.sender, recordId, block.timestamp);

        Record memory r = records[patient][recordId];
        return (r.ipsHash, r.encryptedKeyHash);
    }
}
