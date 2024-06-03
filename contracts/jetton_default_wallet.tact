import "./messages.tact";

@interface("org.ton.jetton.wallet")
contract JettonDefaultWallet {
  balance: Int as coins = 0;
  owner: Address;
  master: Address;

  init(owner: Address, master: Address) {
    self.owner = owner;
    self.master = master;
  }

  receive(msg: TokenTransfer) {
    let ctx: Context = context();
    require(ctx.sender == self.owner, "invalid_sender");

    self.balance -= msg.amount;
    require(self.balance >= 0, "invalid_balance");

    let init: StateInit = initOf JettonDefaultWallet(msg.sender, self.master);
    let wallet_address: Address = contractAddress(init);

    send(SendParameters{
      to: wallet_address,
      value: 0,
      mode: SendRemainingValue,
      bounce: false,
      body: TokenTransferInternal{
        query_id: msg.query_id,
        amount: msg.amount,
        from: self.owner,
        response_destination: msg.response_destination,
        forward_ton_amount: msg.forward_ton_amount,
        forward_payload:  msg.forward_payload
      }.toCell(),
      code: init.code,
      data: init.data
    });
  }
}