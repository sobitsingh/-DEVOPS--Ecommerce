# Create an Internet Gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.open_tele_vpc.id
  tags = {
    Name = "open-tele-igw"
  }
}

# Create a public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.open_tele_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "open-tele-public-rt"
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count                   = 2 # Create exactly 2 public subnets
  vpc_id                  = aws_vpc.open_tele_vpc.id
  cidr_block              = var.public-subnet-cidr_block[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_public[count.index]
  tags = {
    Name = "open-tele-public-subnet-${count.index + 1}"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public" {
  count          = 2 # Associate exactly 2 public subnets
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Create private subnets
resource "aws_subnet" "private" {
  count            = 2 # Create exactly 2 private subnets
  vpc_id           = aws_vpc.open_tele_vpc.id
  cidr_block       = var.private-subnet-cidr_block[count.index]
  availability_zone = var.availability_zone_private[count.index]  
  tags = {
    Name = "open-tele-private-subnet-${count.index + 1}"
  }
}

# Create a NAT Gateway for private subnets
resource "aws_eip" "nat" {
  count = 1 # Create 1 NAT Gateway (shared by private subnets)
  vpc   = true
  tags = {
    Name = "open-tele-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = 1 # Create 1 NAT Gateway (shared by private subnets)
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id # Place NAT Gateway in the first public subnet
  tags = {
    Name = "open-tele-nat-gateway"
  }
}

# Create a private route table
resource "aws_route_table" "private_rt" {
  count = 2 # Create 2 private route tables (one for each private subnet)
  vpc_id = aws_vpc.open_tele_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id # Use the shared NAT Gateway
  }
  tags = {
    Name = "open-tele-private-rt-${count.index + 1}"
  }
}

# Associate private subnets with the private route table
resource "aws_route_table_association" "private" {
  count          = 2 # Associate exactly 2 private subnets
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}
