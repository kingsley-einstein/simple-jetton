import "@stdlib/ownable";
import "../messages.tact";

@interface("org.ton.jetton.master")
trait Jetton with Ownable {
  owner: Address;
  total_supply: Int;
  mintable: Bool;
  content: Cell;

  receive(msg: TokenUpdateContent) {
    self.requireOwner();
    self.content = msg.content;
  }

  receive(msg: TokenBurnNotification) {
    self.requireSenderAsWalletOwner(msg.response_destination!!);
  }
}