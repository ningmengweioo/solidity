# NFT拍卖市场项目

这是一个基于Hardhat框架的NFT拍卖市场项目，支持以下功能：
- NFT创建和管理
- 拍卖创建和参与
- 支持以太币和ERC20代币出价
- 集成Chainlink预言机进行价格转换
- 使用UUPS代理模式支持合约升级
- 使用工厂模式管理拍卖

## 快速开始

### 安装依赖

```bash
npm install
```

### 配置环境变量

复制.env.example文件并填写必要的信息：

```bash
cp .env.example .env
```

### 编译合约

```bash
npx hardhat compile
```

### 运行测试

```bash
npx hardhat test
```

### 部署到测试网

```bash
npx hardhat run --network sepolia deploy/01_deploy_nft.js
npx hardhat run --network sepolia deploy/02_deploy_price_oracle.js
npx hardhat run --network sepolia deploy/03_deploy_auction_system.js
```

### 验证合约

```bash
npx hardhat verify --network sepolia <CONTRACT_ADDRESS> <CONSTRUCTOR_ARGS>
```

## 项目结构

- `contracts/`: 智能合约源码
  - `MyNFT.sol`: NFT合约
  - `PriceOracle.sol`: 价格预言机合约
  - `Auction.sol`: 拍卖合约
  - `AuctionFactory.sol`: 拍卖工厂合约
  - `interfaces/`: 合约接口
- `deploy/`: 部署脚本
- `test/`: 测试脚本
- `hardhat.config.js`: Hardhat配置文件

## 功能说明

### NFT合约
- 支持铸造NFT
- 支持授权NFT用于拍卖

### 拍卖系统
- 创建拍卖：卖家可以将NFT上架拍卖
- 参与拍卖：买家可以使用以太币或ERC20代币出价
- 结束拍卖：拍卖结束后，NFT转移给出价最高者，资金转移给卖家
- 取消拍卖：卖家可以取消拍卖

### 价格预言机
- 集成Chainlink预言机，获取ERC20和以太坊到美元的价格
- 支持在拍卖中比较不同代币的出价

### 合约升级
- 使用UUPS代理模式支持拍卖合约和工厂合约的安全升级

## 注意事项

- 部署到测试网时，需要确保有足够的测试币
- 实际使用中，需要替换Chainlink价格Feed为真实地址
- 合约升级需要谨慎操作，确保新实现与旧实现兼容