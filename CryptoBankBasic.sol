//Licencia
// SPDX-Licence-Identifier: GPL-3.0
pragma solidity 0.8.24;
/**
 * @title CryptoBankBasic
 * @dev Contrato bancario básico que permite a múltiples usuarios depositar y retirar Ether
 * con un límite máximo configurable por usuario. El administrador puede modificar este límite.
 */
contract CryptoBankBasic{
    //@Notice limite maximo de deposito permitido por un usuario
    uint256 public maxBalance;

    //Admin Address
    address public admin;

    //Mapping que almacena el balance de ETH por el user

    mapping (address=>uint256) public userBalance;
    // @notice Emite cuando un usuario deposita Ether.
    // @param user Dirección del usuario.
    // @param amount Cantidad de Ether depositado (en wei)

    event EtherDeposited(address indexed userm,uint256 amount);
    /**
     * @dev Constructor que inicializa el contrato con un balance máximo por usuario y el admin.
     * @param maxBalance_ Cantidad máxima de Ether que puede tener un usuario (en wei).
     * @param admin_ Dirección del administrador del contrato.
     */
    constructor (uint256 maxBalance_, address admin_)
    {
        require(admin_ != address(0), "Admin cannot be zero address");
        require(maxBalance_ > 0, "Max balance must be greater than 0");
        maxBalance = maxBalance_;
        admin = admin_;

    }
    modifier onlyAdmin()
    {
        require(msg.sender==admin,"Not Allowed, admin only can access");
        _;
    }
     /**
     * @notice Permite a un usuario depositar Ether en el contrato.
     * @dev El depósito no puede superar el límite de `maxBalance` por usuario.
     * Lanza un error si se supera el límite.
     */
    function depositEht() external payable {
        require(msg.value>=0,"Deposit must be greater than 0");
        require(
            userBalance[msg.sender]+msg.value<=maxBalance,
            "Deposit exceeds user max balance"
        );
        //Se actualiza el balance interno del usuario
        userBalance[msg.sender]+=msg.value;
        emit EtherDeposited(msg.sender, msg.value);


    }
    /**
     * @notice Permite al usuario retirar parte o la totalidad de su Ether depositado.
     * @param amount Cantidad de Ether a retirar (en wei).
     * @dev Se actualiza el estado antes de enviar Ether para prevenir reentrancia.
     */
    function withdrawEth(uint256 amount) external {
        require(amount > 0, "Withdrawal must be greater than 0");
        require(userBalance[msg.sender] >= amount, "Insufficient balance");

        // Primero se actualiza el balance del usuario
        userBalance[msg.sender] -= amount;

        // Se transfiere el Ether
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "ETH transfer failed");

        //emit EtherWithdrawn(msg.sender, amount);
    }
     /**
     * @notice Permite al administrador modificar el balance máximo permitido por usuario.
     * @param newMaxBalance Nuevo valor para el balance máximo (en wei).
     */
    function modifyBalance(uint256 newMaxBalance) external onlyAdmin {
        require(newMaxBalance > 0, "New max balance must be > 0");
        maxBalance = newMaxBalance;
    }

    /**
     * @notice Retorna el balance total de Ether almacenado en el contrato.
     * @return Balance total del contrato en wei.
     */
    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @dev Evita que se envíe Ether accidentalmente sin llamar a `depositEth`.
    receive() external payable {
        revert("Use depositEth()");
    }

    /// @dev Fallback para prevenir llamadas a funciones inexistentes.
    fallback() external payable {
        revert("Invalid function call");
    }




    
 
}