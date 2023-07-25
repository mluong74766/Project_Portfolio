--Cleaning Data in SQL Queries
SELECT*
FROM PortfolioProject.dbo.NashvilleHousing

--STANARDIZE DATE FORMAT
SELECT SaleDateConverted, Convert(date,SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate=Convert(date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted date;

Update NashvilleHousing
Set SaleDateConverted=Convert(date,SaleDate)

--Populate Property Address Data
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
Order By ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing as a
join PortfolioProject.dbo.NashvilleHousing as b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing as a
join PortfolioProject.dbo.NashvilleHousing as b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--Order By ParcelID

Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress)) as City
FROM PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add PropertySlpitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySlpitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertySlpitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySlpitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))

Select*
From PortfolioProject.dbo.NashvilleHousing


Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress=PARSENAME(Replace(OwnerAddress,',','.'),3)


Alter Table NashvilleHousing
Add OwnerSlpitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSlpitCity=PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState=PARSENAME(Replace(OwnerAddress,',','.'),1)

--Change Y and N to Yes and No in "SoldAsVacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group By SoldAsVacant
order by 2


Select SoldAsVacant,
Case When SoldAsVacant='Y' then 'Yes'
	When SoldAsVacant='N' then 'No'
	Else SoldAsVacant
End
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant = 
Case When SoldAsVacant='Y' then 'Yes'
	When SoldAsVacant='N' then 'No'
	Else SoldAsVacant
End


--Removing Duplicates
With RowNUMCTE As (
Select*,
	ROW_NUMBER() Over(
	partition by ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		Legalreference
		Order By 
			UniqueID
			)row_num
From PortfolioProject.dbo.NashvilleHousing
)

Select *
from RowNUMCTE
where row_num>1
Order By PropertyAddress


--Delete Unused Columns

Select*
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop column OwnerAddress,TaxDistrict,PropertyAddress


Alter Table PortfolioProject.dbo.NashvilleHousing
Drop column SaleDate