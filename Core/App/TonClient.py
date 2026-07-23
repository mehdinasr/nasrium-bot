import os
import base64
import requests
from tonsdk.contract.wallet import Wallets, WalletVersionEnum

TON_NETWORK = os.environ.get("TON_NETWORK", "testnet")
TONCENTER_API_KEY = os.environ.get("TONCENTER_API_KEY", "")
BASE_URL = "https://testnet.toncenter.com/api/v2" if TON_NETWORK == "testnet" else "https://toncenter.com/api/v2"


class TonClient:
    @staticmethod
    def _headers():
        return {"X-API-Key": TONCENTER_API_KEY} if TONCENTER_API_KEY else {}

    @staticmethod
    def get_incoming_transactions(address, limit=20):
        url = f"{BASE_URL}/getTransactions"
        params = {"address": address, "limit": limit, "archival": "true"}
        resp = requests.get(url, params=params, headers=TonClient._headers(), timeout=15)
        resp.raise_for_status()
        return resp.json().get("result", [])

    @staticmethod
    def get_seqno(address):
        url = f"{BASE_URL}/getWalletInformation"
        resp = requests.get(url, params={"address": address}, headers=TonClient._headers(), timeout=15)
        resp.raise_for_status()
        data = resp.json().get("result", {})
        return data.get("seqno", 0)

    @staticmethod
    def send_boc(boc_b64):
        url = f"{BASE_URL}/sendBoc"
        resp = requests.post(url, json={"boc": boc_b64}, headers=TonClient._headers(), timeout=15)
        resp.raise_for_status()
        return resp.json()

    @staticmethod
    def send_transfer(to_address, amount_nano, comment=""):
        mnemonics = os.environ["WALLET_MNEMONIC"].split()
        _, _, _, wallet = Wallets.from_mnemonics(mnemonics, WalletVersionEnum.v4r2, 0)
        from_address = wallet.address.to_string(True, True, True)

        seqno = TonClient.get_seqno(from_address)
        query = wallet.create_transfer_message(
            to_addr=to_address,
            amount=amount_nano,
            seqno=seqno,
            payload=comment
        )
        boc_bytes = query["message"].to_boc(False)
        boc_b64 = base64.b64encode(boc_bytes).decode()
        return TonClient.send_boc(boc_b64)
