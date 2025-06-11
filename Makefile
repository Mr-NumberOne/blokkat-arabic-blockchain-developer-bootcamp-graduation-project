-include .env

deploy:
	@echo "Deploying to the network..."
	@echo "RPC URL: ${RPC_URL}"
	@echo "Owner Address: ${OWNERS_ADDRESS}"
	@echo "Deploying..."
	@echo "Deployed to the network!"
	forge create CauseRegistry --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --broadcast --constructor-args ${OWNERS_ADDRESS} --verify