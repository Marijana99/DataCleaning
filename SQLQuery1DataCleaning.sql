----------Cleaning data in sql Queries---------
Select * 
From Projekat3..NashwileHousing

--standardize date format
Select SaleDateConverted, CONVERT (Date,SaleDate)-- konvertuje date koji je varchar u date
from Projekat3..NashwileHousing

UPDATE NashwileHousing
set SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashwileHousing --dodao je novu kolonu konverted i nju pretvorio u tip datum
Add SaleDateConverted Date;

Update NashwileHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--populate propertz
SELECT PropertyAddress
from Projekat3..NashwileHousing  -- nekretnine koje su null popuni se njihova vrijednost od ranije poznata sa pocetka tabele
--where PropertyAddress is null
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress,b.ParcelId, b.PropertyAddress ,ISNULL(a.PropertyAddress,b.PropertyAddress) -- popunjavanje adrese gdj je null
from Projekat3..NashwileHousing a      -- nenulta vrijednost adrese je ISNULL.... izmedju a i b u tabelama
JOIN Projekat3..NashwileHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null   -- selektuje redove u kojimaje adresa nula


Update a   -- ubacivanje poznatih vrijednosti adresa iz gornjeg upita 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Projekat3..NashwileHousing a      -- nenulta vrijednost adrese je ISNULL.... izmedju a i b u tabelama
JOIN Projekat3..NashwileHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null   -- selektuje redove u kojimaje adresa nula


SELECT PropertyAddress
from Projekat3..NashwileHousing  -- nekretnine koje su null popuni se njihova vrijednost od ranije poznata sa pocetka tabele
--where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING (PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address ,
SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address 

                               --izdvaja se prvi string od citave drese
--CHARINDEX(',',PropertyAddress)
from Projekat3..NashwileHousing


ALTER TABLE Projekat3..NashwileHousing
Add PropertySplitAddress  Nvarchar(255);

Update Projekat3..NashwileHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE Projekat3..NashwileHousing 
Add  PropertySplitCity Nvarchar(255);

Update Projekat3..NashwileHousing
SET  PropertySplitCity = SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


SELECT OwnerAddress
from Projekat3..NashwileHousing


Select 
PARSENAME (REPLACE(OwnerAddress,',','.'),3),--address
PARSENAME (REPLACE(OwnerAddress,',','.'),2),--city
PARSENAME (REPLACE(OwnerAddress,',','.'),1)--state
from Projekat3..NashwileHousing


ALTER TABLE Projekat3..NashwileHousing
Add OwnerSplitAddress  Nvarchar(255);

Update Projekat3..NashwileHousing
SET OwnerSplitAddress = PARSENAME (REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE Projekat3..NashwileHousing---
Add OwnerSplitCity  Nvarchar(255);

Update Projekat3..NashwileHousing
SET OwnerSplitCity = (REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE Projekat3..NashwileHousing
Add OwnerSplitState  Nvarchar(255);

Update Projekat3..NashwileHousing
SET OwnerSplitState= (REPLACE(OwnerAddress,',','.'),1)


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Projekat3..NashwileHousing
Group by SoldAsVacant
order by 2



Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Projekat3..NashwileHousing


Update Projekat3..NashwileHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

	   -- Remove Duplicates


Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Projekat3..NashwileHousing
order by ParcelID




WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Projekat3..NashwileHousing
--order by ParcelID
)

select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select * 
From Projekat3..NashwileHousing


alter table Projekat3..NashwileHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table Projekat3..NashwileHousing
drop column SaleDate


































