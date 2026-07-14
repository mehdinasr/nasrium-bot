import hashlib
import time

class NFTEngine:
    MINT_FEE_SHARDS = 100

    @staticmethod
    def prepare_nft_metadata(player_data, artifact_id):
        # بررسی موجودی شاردها برای هزینه ضرب
        if player_data.get("nsm_shards", 0) < NFTEngine.MINT_FEE_SHARDS:
            return False, f"Insufficient Shards. Need {NFTEngine.MINT_FEE_SHARDS} to mint NFT."

        # تولید شناسه منحصربه‌فرد برای دارایی (Unique Asset ID)
        raw_id = f"{player_data['user_id']}:{artifact_id}:{time.time()}"
        asset_hash = hashlib.sha1(raw_id.encode()).hexdigest().upper()[:12]
        
        metadata = {
            "name": f"Nasrium Artifact #{asset_hash}",
            "description": f"Official Imperial Cyber-Asset minted by {player_data['user_id']}",
            "image": f"https://nasrium.com/assets/nft/{artifact_id}.png",
            "attributes": [
                {"trait_type": "Artifact Type", "value": artifact_id},
                {"trait_type": "Origin", "value": "Imperial Forge"}
            ],
            "asset_id": f"NSM-NFT-{asset_hash}"
        }
        
        # کسر هزینه و ثبت در لیست NFTهای بازیکن
        player_data["nsm_shards"] -= NFTEngine.MINT_FEE_SHARDS
        nfts = player_data.get("minted_nfts", [])
        nfts.append(metadata)
        player_data["minted_nfts"] = nfts
        
        return True, metadata
