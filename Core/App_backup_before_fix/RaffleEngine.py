import random

class RaffleEngine:
    TICKET_COST = 1000 # NSM Soft
    BURN_RATE = 0.20   # ۲۰٪ توکن‌سوزی

    @staticmethod
    def buy_ticket(player_data):
        if player_data.get("nsm_soft", 0) < RaffleEngine.TICKET_COST:
            return False, "Insufficient NSM Soft for ticket."
        
        player_data["nsm_soft"] -= RaffleEngine.TICKET_COST
        player_data["raffle_tickets"] = player_data.get("raffle_tickets", 0) + 1
        return True, "Imperial Raffle Ticket acquired. Good luck, Commander."

    @staticmethod
    def calculate_jackpot(total_tickets):
        total_nsm = total_tickets * RaffleEngine.TICKET_COST
        burn_amount = int(total_nsm * RaffleEngine.BURN_RATE)
        jackpot = total_nsm - burn_amount
        return jackpot, burn_amount
