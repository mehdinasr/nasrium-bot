import time
import uuid

class TransferEngine:
    @staticmethod
    def record_transaction(db, from_id, to_id, amount, asset_type):
        # تولید کد رهگیری منحصر‌به‌فرد ناصریوم
        tx_id = f"NSM-TX-{uuid.uuid4().hex[:12].upper()}"
        
        entry = {
            "tx_id": tx_id,
            "from_user": from_id,
            "to_user": to_id,
            "amount": amount,
            "asset_type": asset_type,
            "timestamp": time.time(),
            "status": "COMPLETED"
        }
        db.transactions.insert_one(entry)
        return tx_id

    @staticmethod
    def send_assets(db, from_id, to_id, amount, asset_type):
        if from_id == to_id: return False, "Cannot send to yourself.", None
        
        sender = db.players.find_one({"user_id": from_id})
        receiver = db.players.find_one({"user_id": to_id})
        
        if not receiver: return False, "Destination citizen not found.", None
        if sender.get(asset_type, 0) < amount: return False, f"Insufficient {asset_type}.", None

        # عملیات انتقال دوطرفه (Atomic-like)
        db.players.update_one({"user_id": from_id}, {"$inc": {asset_type: -amount}})
        db.players.update_one({"user_id": to_id}, {"$inc": {asset_type: amount}})
        
        # ثبت در دفتر کل
        tx_id = TransferEngine.record_transaction(db, from_id, to_id, amount, asset_type)
        
        # ثبت در لاگ‌های شخصی
        from Core.App.PlayerRepository import PlayerRepository
        PlayerRepository.add_log(from_id, f"Sent {amount} {asset_type} to {to_id}. TX: {tx_id}")
        PlayerRepository.add_log(to_id, f"Received {amount} {asset_type} from {from_id}. TX: {tx_id}")
        
        return True, "Transfer Successful", tx_id
