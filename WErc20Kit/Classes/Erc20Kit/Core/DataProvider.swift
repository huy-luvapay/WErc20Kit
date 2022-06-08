import WEthereumKit
import RxSwift
import BigInt

class DataProvider {
    private let ethereumKit: WEthereumKit.Kit

    init(ethereumKit: WEthereumKit.Kit) {
        self.ethereumKit = ethereumKit
    }

}

extension DataProvider: IDataProvider {

    func getBalance(contractAddress: Address, address: Address) -> Single<BigUInt> {
        ethereumKit.call(contractAddress: contractAddress, data: BalanceOfMethod(owner: address).encodedABI())
                .flatMap { data -> Single<BigUInt> in
                    guard let value = BigUInt(data.prefix(32).hex, radix: 16) else {
                        return Single.error(TokenError.invalidHex)
                    }

                    return Single.just(value)
                }
    }

}
